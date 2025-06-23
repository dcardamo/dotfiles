# Development Containers with OrbStack

This system provides Ubuntu-based development containers running on OrbStack with Nix and home-manager, giving you isolated development environments with your full dotfiles setup.

## Features

- **Consistent Environment**: All containers use your home-manager configuration
- **File Access**: Read-write access to `~/git` directory
- **Direct Shell Access**: Use `dc shell` to connect via docker exec
- **GitHub Integration**: SSH keys mounted read-only for git operations
- **Isolation**: Each project can have its own container
- **Fast**: Leverages OrbStack's performance optimizations

## Prerequisites

1. OrbStack installed on your Mac
2. This dotfiles repository cloned locally
3. SSH keys set up in `~/.ssh/` (for git operations)

## Quick Start

```bash
# Create a new dev container
dc create myproject

# Open a shell in the container  
dc shell myproject

# List all containers
dc list

# Destroy a container
dc destroy myproject
```

## Usage

### Create a new dev container

```bash
dc create myproject
```

This will:
1. Create an Ubuntu-based container named `dev-myproject`
2. Install Nix and home-manager
3. Apply your dotfiles configuration
4. Mount `~/git` for development work
5. Mount `~/.ssh` (read-only) for git operations

### Open a shell in a container

```bash
dc shell myproject
```

This opens an interactive zsh session in your container with your full development environment.

### List containers

```bash
dc list
```

Shows all development containers and their status.

### Execute commands

```bash
dc exec myproject 'cd ~/git/myproject && nix develop'
```

Run commands in the container without opening an interactive shell.

### Rebuild configuration

After updating your dotfiles:
```bash
dc rebuild myproject
```

This will pull the latest dotfiles and reapply your home-manager configuration.

### Start/Stop containers

```bash
dc stop myproject    # Stop a running container
dc start myproject   # Start a stopped container
```

### Destroy a container

```bash
dc destroy myproject  # Will prompt for confirmation
dc force-destroy myproject  # No confirmation prompt
```

## Architecture

### Container Setup

1. **Base**: Ubuntu 22.04 running via Docker (OrbStack)
2. **User**: `dan` user with UID 501 (matching macOS)
3. **Shell**: Full zsh + helix setup from home-manager
4. **Mounts**: 
   - `~/git` → `/home/dan/git` (read-write)
   - `~/.ssh` → `/mnt/host-ssh` (read-only, for git keys)
   - `~/dotfiles` → `/mnt/dotfiles` (read-only)

### Security

- Direct shell access via `docker exec` (no SSH required)
- SSH keys available for git operations only
- Each container is isolated
- Containers run unprivileged

### File Permissions

The container user has UID 501 and uses the staff group, ensuring files created in the container have the correct ownership on the host.


## Tips

### Using with nix develop

Each container has full Nix support. You can use `nix develop` in any project:

```bash
dc shell myproject
cd ~/git/myproject
nix develop
```

### Multiple containers

You can create multiple containers for different projects:

```bash
dc create frontend
dc create backend
dc create experiments
```

### Customizing containers

The container uses your standard home-manager configuration. To customize:
1. Edit your home-manager modules
2. Run `dc rebuild <name>`

## Troubleshooting

### Container won't start
- Check Docker is running: `docker ps`
- Check container status: `docker ps -a | grep dev-`
- View logs: `docker logs dev-<name>`

### Permission issues with git
- Ensure your SSH keys are mounted: `dc exec <name> 'ls -la /mnt/host-ssh/'`
- Check git config: `dc exec <name> 'git config --list'`

### Home-manager fails
- Check nix channels: `dc exec <name> 'nix-channel --list'`
- Update channels: `dc exec <name> 'nix-channel --update'`
- View home-manager logs during rebuild

### Shell issues
If zsh is not available, the shell command will fall back to bash automatically.