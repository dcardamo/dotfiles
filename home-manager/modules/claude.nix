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
          "@modelcontextprotocol/server-sqlite"
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
        ] ++ map (p: "--allowed-path=${p}") paths;
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
      claude-code
      # nodejs_20 is provided by nodejs.nix
    ];

    # Claude configuration directory
    home.file.".claude/settings.json".source = claudeSettings;

    # MCP configuration for user scope
    # Note: Claude Code currently requires adding MCP servers via CLI
    # This file serves as a reference for what should be configured
    home.file.".config/claude/mcp-reference.json".source = mcpConfig;

    # Create setup script for MCP servers
    home.file.".config/claude/setup-mcp-servers.sh" = {
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

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
              claude mcp add --transport stdio --scope user "sqlite-${name}" npx @modelcontextprotocol/server-sqlite --db-path "${dbPath}"
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
    };
  };
}
