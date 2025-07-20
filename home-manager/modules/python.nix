# Python Development Environment Configuration
#
# This module provides a comprehensive Python development setup with:
# - System-wide Python tools (formatters, linters, LSP server)
# - uv: Ultra-fast Python package manager for project-specific dependencies
# - Environment configured to work well with Nix-managed Python
#
# Usage:
#   System tools (always available):
#   - ruff: Fast Python linter and formatter
#   - black: Python code formatter
#   - flake8: Python linter
#   - isort: Import statement organizer
#   - python-lsp-server: Language Server Protocol implementation
#   - pgformatter: PostgreSQL SQL formatter
#
#   Project-specific Python management with uv:
#   - uv init: Initialize a new Python project
#   - uv add <package>: Add dependencies to your project
#   - uv sync: Install dependencies from pyproject.toml
#   - uv run <command>: Run commands in the project environment
#   - uv python install <version>: Install a specific Python version
#
# Note: UV_PYTHON_DOWNLOADS is set to "never" to ensure uv uses
# Nix-managed Python installations instead of downloading its own.
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Python formatters and linters
    pgformatter
    ruff

    # Python package manager
    uv

    # Python with packages
    (python312.withPackages
      (p:
        with p; [
          black
          flake8
          isort
          python-lsp-black
          python-lsp-server
        ]))
  ];

  # Environment variables for uv
  home.sessionVariables = {
    # Prevent uv from downloading Python binaries (use Nix-managed ones)
    UV_PYTHON_DOWNLOADS = "never";
  };
}
