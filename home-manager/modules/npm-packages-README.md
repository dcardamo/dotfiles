# NPM Packages Module

This module provides automatic installation of global npm packages through home-manager.

## Usage

Enable the module in your `home.nix`:

```nix
programs.npmPackages = {
  enable = true;
  packages = [
    "@upstash/context7-mcp"
    "mcp-sqlite"
    "@modelcontextprotocol/server-filesystem"
    "typescript"
    "prettier"
    # Add more packages as needed
  ];
};
```

## Features

- Automatically installs or updates npm packages globally when running `home-manager switch`
- Configures npm prefix to `~/.npm-global` by default
- Integrates with the PATH configuration (already set up in zsh)

## How it works

1. The module creates/updates `.npmrc` with the global prefix
2. During `home.activation`, it runs `npm install -g` for each requested package (updating if already present)
3. Packages are installed to `~/.npm-global`
4. The PATH already includes `~/.npm-global/bin` (from zsh configuration)

## Claude Code Installation

Currently, Claude Code CLI is installed via nix in the `claude.nix` module. When/if an official npm package becomes available, you can add it to the packages list:

```nix
packages = [
  # ... other packages
  "@anthropic/claude-code"  # When available
];
```
