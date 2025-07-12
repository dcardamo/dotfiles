# Dan's Nix-Powered Dotfiles

A comprehensive Nix Flakes-based configuration for macOS and NixOS/Linux systems, featuring declarative system management, development containers, and modern developer tooling.

## 🎯 Core Features

### 📦 Nix Configuration Management
- **Nix Flakes**: Reproducible, declarative system and user configurations
- **Home Manager**: Manage user environments across macOS and Linux
- **Cross-Platform**: Unified configuration for Darwin (macOS) and NixOS systems
- **Multiple Machines**: Pre-configured for mars, venus (macOS), neptune, arcee, heatwave (NixOS)

### 🐳 Development Containers (`dc` script)
- **Instant Dev Environments**: Create isolated Ubuntu containers with full Nix tooling
- **Port Forwarding**: Easy port mapping for web development
- **HTTP/HTTPS Proxies**: Built-in Caddy proxy with basic auth support
- **Persistent Workspaces**: Shared `~/git` directory across host and containers
- **SSH & GitHub Integration**: Automatic credential forwarding
- **Platform Aware**: Optimized for both ARM64 (Apple Silicon) and x86_64

### 🛠️ Development Environment
- **Language Support**: Pre-configured environments for Rust, JavaScript, Elixir with PostgreSQL
- **Nix Devenv Templates**: Reproducible project environments with `devenv.nix`
- **Editor Integration**: Neovim, Helix, Zed, Ghostty terminal configurations
- **Shell Enhancements**: Zsh with custom functions, aliases, and productivity tools

### 🌳 Git Workflow
- **Worktree Manager (`wt`)**: Organized branch management with automatic naming
- **Environment Propagation**: `.env` files automatically copied to new worktrees
- **PR Integration**: Create worktrees directly from GitHub pull requests
- **Shell Integration**: Automatic directory navigation and tab completion

### 🖥️ Terminal & Shell
- **Zellij**: Multiplexer with Tokyo Night theme and mobile-friendly layouts
- **Enhanced CLI**: `bat`, `lsd`, `ripgrep`, `duf` for better command-line experience
- **Ghostty**: Modern terminal with Iosevka Nerd Font
- **Smart Aliases**: Platform-aware commands and productivity shortcuts

### 🤖 AI Integration
- **Claude Code CLI**: Command-line access to Claude
- **Editor Support**: Neovim Avante plugin for in-editor AI assistance
- **MCP Servers**: Context7 for documentation access and SQLite integration

## 🖥️ Supported Systems

### macOS Machines
- **mars** - Apple Silicon Mac with machine-specific Brewfile
- **venus** - Apple Silicon Mac with custom configurations

### NixOS/Linux Systems
- **neptune** - GMKtec EVO-X2 with AMD Ryzen AI Max 395
- **arcee** - Home docker server (x86_64-linux)
- **heatwave** - Cottage docker server (x86_64-linux)
- **devcontainer** - Development containers for various architectures

## 📋 Prerequisites

- **macOS**: Command Line Tools (`xcode-select --install`)
- **Linux**: Git and curl
- **All Systems**: GitHub SSH key for repository access

## 🚀 Quick Start

### macOS Installation

1. Clone the repository:
```bash
cd ~
git clone git@github.com:dcardamo/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles
```

2. Symlink machine-specific Brewfile:
```bash
ln -sf Brewfile.$HOSTNAME Brewfile
```

3. Run installation:
```bash
make install
```

4. Add yourself to trusted users in `/etc/nix/nix.conf`:
```
trusted-users = root <your-username>
```

5. Restart nix daemon:
```bash
sudo pkill nix-daemon
```

### Updates

**⚠️ IMPORTANT**: Never use `home-manager switch` directly!

```bash
make update          # Update home-manager configuration
make update-system   # Update system packages
make update-all      # Update everything
```

## 🐳 Development Containers (`dc`)

The `dc` script provides Docker-based development environments with full Nix tooling:

### Creating Containers

```bash
dc create myproject                      # Basic container
dc create myproject -p 3000:3000         # With port forwarding
dc create myproject --proxy-http 8080:3000   # With HTTP proxy
```

### Managing Containers

```bash
dc list                  # List all containers
dc shell myproject       # Open shell in container
dc exec myproject "command"  # Run command in container
dc stop myproject        # Stop container
dc start myproject       # Start container
dc destroy myproject     # Remove container
```

### Features
- Full Nix and home-manager setup in each container
- Shared git directory with host
- SSH keys and GitHub CLI configuration
- Claude configuration and MCP servers
- Chromium/Chrome for Puppeteer support
- HTTP/HTTPS proxy with Caddy

## 🛠️ Common Workflows

### Git Worktree Management

Create a new worktree:
```bash
wt new feature-name              # Creates dan/feature-name branch
wt new feature-name main         # Create from specific base branch
```

Create worktree from PR:
```bash
wt pr 123                        # Creates worktree from PR #123
```

List worktrees:
```bash
wt list                          # Show all worktrees
wt                              # CD to main worktree
```

### Development Environments

Create a new project with devenv:
```bash
cd ~/projects/my-rust-app
cp ~/git/dotfiles/devenv-templates/rust-postgres.nix devenv.nix
direnv allow
```

## 🔧 Configuration

### Key Files
- `flake.nix` - Main Nix flake configuration
- `home-manager/modules/` - User environment modules
- `nixos/<hostname>/` - Machine-specific NixOS configurations
- `CLAUDE.md` - Instructions for Claude AI
- `Makefile` - Common tasks and updates
- `bin/dc` - Development container management script

### Environment Variables
- `ANTHROPIC_API_KEY` - Claude API key (optional)
- `OPENAI_API_KEY` - OpenAI API key for additional tools

## 🐛 Troubleshooting

### Nix Issues
- **"experimental features" error**: Ensure `~/.config/nix/nix.conf` has experimental features enabled
- **Permission denied**: Check trusted users configuration
- **Build failures**: Try `nix flake update` then rebuild

### Development Containers
- **Docker not found**: Install OrbStack (macOS) or Docker
- **Container creation fails**: Check Docker daemon is running
- **Port conflicts**: Use different host ports when creating containers

### Platform-Specific
- **macOS sandbox issues**: Claude runs with `--no-sandbox` on macOS automatically
- **Linux permission errors**: Ensure your user is in necessary groups

## 📦 NixOS Installation

<details>
<summary>Click to expand full NixOS installation guide</summary>

### Installing on a new NixOS machine

1. Boot into NixOS installer

2. Partition and format drives:

   **UEFI Setup:**
   ```bash
   sudo fdisk /dev/diskX
   g                    # Create GPT disk label
   n                    # New partition
   1                    # Partition number
   2048                 # First sector
   +500M                # Last sector (boot partition)
   t                    # Change type
   1                    # Select EFI System
   n                    # New partition
   2                    # Partition number
   <enter>              # Default first sector
   <enter>              # Default last sector (use remaining space)
   w                    # Write changes
   ```

   **Format and mount:**
   ```bash
   sudo mkfs.fat -F 32 /dev/sdX1
   sudo fatlabel /dev/sdX1 NIXBOOT
   sudo mkfs.ext4 /dev/sdX2 -L NIXROOT
   sudo mount /dev/disk/by-label/NIXROOT /mnt
   sudo mkdir -p /mnt/boot
   sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot
   ```

   **Create swap file:**
   ```bash
   sudo dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152  # 2GB
   sudo chmod 600 /mnt/.swapfile
   sudo mkswap /mnt/.swapfile
   sudo swapon /mnt/.swapfile
   ```

3. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --root /mnt
   ```

4. Setup SSH access:
   ```bash
   passwd  # Set password for nixos user
   # From another machine:
   scp ~/.ssh/id_ed25519* nixos@<new-machine-ip>:.ssh/
   ```

5. Clone and configure:
   ```bash
   nix-shell -p git helix
   cd ~
   git clone git@github.com:dcardamo/dotfiles.git
   cp /mnt/etc/nixos/hardware-configuration.nix dotfiles/nixos/<hostname>/
   ```

6. Install the system:
   ```bash
   cd ~/dotfiles
   sudo nixos-install --flake .#<hostname>
   ```

7. Commit changes before reboot:
   ```bash
   git config --global user.email "your-email@example.com"
   git config --global user.name "Your Name"
   git add .
   git commit -m "Add <hostname> configuration"
   git push origin
   ```

8. After reboot:
   ```bash
   sudo passwd <your-username>
   ```

</details>

## 🙏 Acknowledgments

This configuration draws inspiration from:
- [mrjones2014/dotfiles](https://github.com/mrjones2014/dotfiles)
- [treffynnon/nix-setup](https://github.com/treffynnon/nix-setup)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [hmajid2301/dotfiles](https://gitlab.com/hmajid2301/dotfiles)

## 📄 License

Feel free to use and adapt these configurations for your own setup!