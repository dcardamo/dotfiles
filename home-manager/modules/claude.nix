{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.claude;

  # MCP server configurations
  mcpServers = {
    # SQLite MCP Server configuration
    sqlite = name: dbPath: {
      "sqlite-${name}" = {
        command = "npx";
        args = [
          "-y"
          "mcp-sqlite"
          "--db-path"
          dbPath
        ];
      };
    };

    # Context7 MCP Server for up-to-date documentation
    context7 = {
      "context7" = {
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp"
        ];
      };
    };

    # Filesystem MCP Server
    filesystem = paths: {
      "filesystem" = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-filesystem"
        ]
        ++ map (p: "--allowed-path=${p}") paths;
      };
    };
  };

  # Generate MCP configuration file
  mcpConfig = pkgs.writeTextFile {
    name = "claude-mcp-config.json";
    text =
      let
        servers = mkMerge (
          [
            # Always include Context7 for documentation
            mcpServers.context7
          ]
          ++ optionals (cfg.sqlite.databases != { }) (
            mapAttrsToList (name: dbPath: mcpServers.sqlite name dbPath) cfg.sqlite.databases
          )
          ++ optionals (cfg.filesystem.paths != [ ]) [
            (mcpServers.filesystem cfg.filesystem.paths)
          ]
        );
      in
      builtins.toJSON {
        mcpServers = servers;
      };
  };

  # Claude settings file
  claudeSettings = pkgs.writeTextFile {
    name = "claude-settings.json";
    text = builtins.toJSON (
      {
        model = cfg.defaultModel;
      }
      // (optionalAttrs cfg.ntfyNotifications.enable {
        hooks = {
          Stop = [
            {
              hooks = [
                {
                  type = "command";
                  command = "${config.home.homeDirectory}/.config/claude/send-ntfy-notification.sh";
                }
              ];
            }
          ];
        };
      })
      // cfg.extraSettings
    );
  };

  # CLAUDE.md template for new projects
  claudeMdTemplate = pkgs.writeText "CLAUDE.md.template" ''
    # CLAUDE.md

    This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

    ## Project Overview

    [Describe your project here]

    ## Architecture

    [Describe the architecture]

    ## Key Components

    [List key components]

    ## Development Guidelines

    - Follow existing code style and conventions
    - Use available tools and libraries already in the project
    - Prioritize security best practices
    - Write tests for new functionality

    ## Available MCP Servers

    ${optionalString (
      cfg.sqlite.databases != { }
    ) "- SQLite databases: ${concatStringsSep ", " (attrNames cfg.sqlite.databases)}"}
    ${optionalString cfg.context7.enable "- Context7: Use 'use context7' in prompts for up-to-date documentation"}
    ${optionalString (
      cfg.filesystem.paths != [ ]
    ) "- Filesystem access: ${concatStringsSep ", " cfg.filesystem.paths}"}

    ## Notes

    [Any additional notes]
  '';
in
{
  options.programs.claude = {
    enable = mkEnableOption "Claude Code configuration";

    defaultModel = mkOption {
      type = types.enum [
        "opus"
        "sonnet"
        "haiku"
      ];
      default = "opus";
      description = "Default Claude model to use";
    };

    extraSettings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Extra settings to add to Claude configuration";
    };

    ntfyNotifications = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable ntfy.sh notifications when Claude completes";
      };

      topicUrl = mkOption {
        type = types.str;
        default = "";
        example = "https://ntfy.sh/my_topic";
        description = "ntfy.sh topic URL for notifications";
      };
    };

    sqlite = {
      databases = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = literalExpression ''
          {
            "myapp" = "/path/to/myapp.db";
            "analytics" = "/path/to/analytics.db";
          }
        '';
        description = "SQLite databases to make available via MCP";
      };
    };

    context7 = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Context7 MCP server for up-to-date documentation";
      };
    };

    filesystem = {
      paths = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [
          "$HOME/projects"
          "/tmp"
        ];
        description = "Filesystem paths to allow access via MCP";
      };
    };

    projectDefaults = {
      enableClaudeMd = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to create CLAUDE.md files in new projects";
      };
    };

    allowedTools = mkOption {
      type = types.listOf types.str;
      default = [
        "Read"
        "Glob"
        "Grep"
        "LS"
        "TodoRead"
        "TodoWrite"
        "WebSearch"
        "WebFetch"
        "NotebookRead"
        "mcp__context7__resolve-library-id"
        "mcp__context7__get-library-docs"
      ];
      example = [
        "Read"
        "Grep"
        "LS"
        "Bash"
      ];
      description = ''
        List of tools that Claude can use without confirmation.
        Common safe tools include:
        - Read: Read file contents
        - Glob: Find files by pattern
        - Grep: Search file contents
        - LS: List directory contents
        - TodoRead/TodoWrite: Manage task lists
        - WebSearch/WebFetch: Search and fetch web content
        - NotebookRead: Read Jupyter notebooks
        - Bash: Run shell commands (use with caution)
        - Edit/Write: Modify files (use with caution)
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # claude-code # Using npm version instead
      # nodejs_20 is provided by nodejs.nix
    ];

    # Claude Code CLI is now installed via npm-packages module

    # Claude configuration directory
    # Don't use home.file to create a read-only symlink
    # Instead, we'll copy the file in the setup script

    # MCP configuration for user scope
    # Note: Claude Code currently requires adding MCP servers via CLI
    # This file serves as a reference for what should be configured
    home.file.".config/claude/mcp-reference.json".source = mcpConfig;

    # Store the settings template for copying during update
    home.file.".config/claude/settings-template.json".source = claudeSettings;

    # Create setup script for MCP servers and settings
    home.file.".config/claude/setup-mcp-servers.sh" = {
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        echo "Setting up Claude configuration..."

        # Create ~/.claude directory if it doesn't exist
        mkdir -p ~/.claude

        # Copy settings template to writable location if it doesn't exist or during update
        if [ ! -f ~/.claude/settings.json ] || [ "$1" = "update" ]; then
          echo "Updating Claude settings.json..."
          cp ~/.config/claude/settings-template.json ~/.claude/settings.json
          chmod 644 ~/.claude/settings.json
          echo "Claude settings.json updated (writable)"
        fi

        echo "Setting up Claude MCP servers..."

        # Add Context7 if enabled
        ${optionalString cfg.context7.enable ''
          if ! claude mcp list 2>/dev/null | grep -q "context7"; then
            echo "Adding Context7 documentation server..."
            claude mcp add --transport stdio --scope user context7 npx @upstash/context7-mcp
          fi
        ''}

        # Add SQLite databases
        ${concatStringsSep "\n" (
          mapAttrsToList (name: dbPath: ''
            if ! claude mcp list 2>/dev/null | grep -q "sqlite-${name}"; then
              echo "Adding SQLite server '${name}' for database: ${dbPath}"
              claude mcp add --transport stdio --scope user "sqlite-${name}" npx mcp-sqlite --db-path "${dbPath}"
            fi
          '') cfg.sqlite.databases
        )}

        # Add filesystem paths
        ${optionalString (cfg.filesystem.paths != [ ]) ''
          if ! claude mcp list 2>/dev/null | grep -q "filesystem"; then
            echo "Adding filesystem server with paths: ${concatStringsSep ", " cfg.filesystem.paths}"
            claude mcp add --transport stdio --scope user filesystem npx @modelcontextprotocol/server-filesystem ${
              concatMapStringsSep " " (p: "--allowed-path=\"${p}\"") cfg.filesystem.paths
            }
          fi
        ''}

        echo "MCP server setup complete!"
        claude mcp list
      '';
      executable = true;
    };

    # CLAUDE.md template
    home.file.".config/claude/CLAUDE.md.template".source = claudeMdTemplate;

    # ntfy notification script
    home.file.".config/claude/send-ntfy-notification.sh" = mkIf cfg.ntfyNotifications.enable {
      text = ''
        #!/usr/bin/env bash

        # Send notification to ntfy.sh when Claude completes
        TOPIC_URL="${cfg.ntfyNotifications.topicUrl}"
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        HOSTNAME=$(hostname)

        # Read the hook input from stdin
        HOOK_INPUT=$(cat)

        # Extract transcript path from the input
        TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | ${pkgs.jq}/bin/jq -r '.transcript_path // empty')

        # Default summary
        TASK_SUMMARY="Task completed"
        WORKING_DIR=$(pwd)

        # If we have a transcript, try to extract context
        if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
            # Get the last user message from the transcript (max 100 chars)
            LAST_USER_MSG=$(tail -n 20 "$TRANSCRIPT_PATH" | ${pkgs.jq}/bin/jq -r 'select(.role == "user") | .content' | tail -1 | head -c 100)

            # Create a short summary (first 5 words or 30 chars)
            if [ -n "$LAST_USER_MSG" ]; then
                # Take first 5 words or 30 characters, whichever is shorter
                TASK_SUMMARY=$(echo "$LAST_USER_MSG" | awk '{for(i=1;i<=5&&i<=NF;i++)printf "%s ",$i}' | head -c 30 | sed 's/[[:space:]]*$//')
                [ -n "$TASK_SUMMARY" ] && TASK_SUMMARY="''${TASK_SUMMARY}..."
            fi
        fi

        # Send the notification with context
        ${pkgs.curl}/bin/curl -X POST "''${TOPIC_URL}" \
          -H "Title: Claude Completed: ''${TASK_SUMMARY}" \
          -H "Priority: default" \
          -H "Tags: robot,white_check_mark" \
          -d "Finished at ''${TIMESTAMP} in ''${WORKING_DIR}"

        # Exit with success to not block Claude
        exit 0
      '';
      executable = true;
    };

    # Claude custom commands
    home.file.".claude/commands/worktree-new.md".source = ./claude/commands/worktree-new.md;
    home.file.".claude/commands/worktree-prune.md".source = ./claude/commands/worktree-prune.md;
    home.file.".claude/commands/worktree-pr.md".source = ./claude/commands/worktree-pr.md;
    home.file.".claude/commands/worktree-pr-fix.md".source = ./claude/commands/worktree-pr-fix.md;

    # Environment variables (no API key needed!)
    home.sessionVariables = {
      CLAUDE_MCP_ENABLED = "1";
      CLAUDE_DEFAULT_MODEL = cfg.defaultModel;
      # Ensure no API key is accidentally used
      ANTHROPIC_API_KEY = "";
      # Force color output for Claude Code (fixes Termius/SSH color issues)
      COLORTERM = "truecolor";
      # Additional color support
      TERM = lib.mkDefault "xterm-256color";
    };
  };
}
