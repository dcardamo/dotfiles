#!/bin/bash
set -e

# Simple astrophotography sync script
# Usage:
#   ./sync-jupiter.sh              - Run sync normally regardless of power status
#   ./sync-jupiter.sh --cron       - Only run if on AC power (for scheduled runs)
#   ./sync-jupiter.sh --cron-install   - Install as hourly launchd service
#   ./sync-jupiter.sh --cron-uninstall - Remove launchd service

# Configuration
REMOTE="astro@jupiter"
LOCAL_DIR="$HOME/astro/jupiter"
PLIST_NAME="com.user.sync-jupiter"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_NAME}.plist"
LOG_DIR="$HOME/Library/Logs"

# Function to check if on AC power
is_on_ac_power() {
    # Use pmset to check power source
    power_source=$(pmset -g ps | head -1)

    # Check if "AC Power" is in the output
    if [[ "$power_source" == *"AC Power"* ]]; then
        return 0  # On AC power
    else
        return 1  # On battery
    fi
}

# Function to log with timestamp
log_message() {
    echo "$(date): $1"
}

# Function to get the absolute path of this script
get_script_path() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local script_name="$(basename "${BASH_SOURCE[0]}")"
    echo "${script_dir}/${script_name}"
}

# Function to create and install the launchd plist
install_cron_service() {
    local script_path
    script_path="$(get_script_path)"

    echo "Installing sync-jupiter as hourly launchd service..."
    echo "Script path: $script_path"

    # Create necessary directories
    mkdir -p "$HOME/Library/LaunchAgents"
    mkdir -p "$LOG_DIR"

    # Create the plist file
    cat > "$PLIST_PATH" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.sync-jupiter</string>

    <key>ProgramArguments</key>
    <array>
        <string>SCRIPT_PATH_PLACEHOLDER</string>
        <string>--cron</string>
    </array>

    <key>StartInterval</key>
    <integer>3600</integer>

    <key>RunAtLoad</key>
    <false/>

    <key>StandardOutPath</key>
    <string>LOG_DIR_PLACEHOLDER/sync-jupiter.log</string>

    <key>StandardErrorPath</key>
    <string>LOG_DIR_PLACEHOLDER/sync-jupiter-error.log</string>
</dict>
</plist>
EOF

    # Replace placeholders with actual values
    sed -i '' "s|SCRIPT_PATH_PLACEHOLDER|$script_path|g" "$PLIST_PATH"
    sed -i '' "s|LOG_DIR_PLACEHOLDER|$LOG_DIR|g" "$PLIST_PATH"

    # Verify the plist was created
    if [[ ! -f "$PLIST_PATH" ]]; then
        echo "❌ Error: Failed to create plist file"
        exit 1
    fi

    echo "✓ Created plist file: $PLIST_PATH"

    # Load the service
    if launchctl load "$PLIST_PATH"; then
        echo "✓ Service loaded successfully!"
    else
        echo "❌ Error: Failed to load service"
        exit 1
    fi

    echo ""
    echo "Service installed successfully!"
    echo "  - Runs every hour when on AC power"
    echo "  - Logs: $LOG_DIR/sync-jupiter.log"
    echo "  - Errors: $LOG_DIR/sync-jupiter-error.log"
    echo "  - Config: $PLIST_PATH"
    echo ""
    echo "Management commands:"
    echo "  Check status: launchctl list | grep sync-jupiter"
    echo "  View logs: tail -f $LOG_DIR/sync-jupiter.log"
    echo "  Uninstall: $0 --cron-uninstall"
}

# Function to uninstall the launchd service
uninstall_cron_service() {
    echo "Uninstalling sync-jupiter launchd service..."

    # Check if service is loaded and unload it
    if launchctl list | grep -q "$PLIST_NAME"; then
        if launchctl unload "$PLIST_PATH"; then
            echo "✓ Service unloaded"
        else
            echo "⚠️  Warning: Failed to unload service (it may not be running)"
        fi
    else
        echo "ℹ️  Service was not loaded"
    fi

    # Remove the plist file
    if [[ -f "$PLIST_PATH" ]]; then
        rm "$PLIST_PATH"
        echo "✓ Configuration file removed: $PLIST_PATH"
    else
        echo "ℹ️  Configuration file not found"
    fi

    echo "✓ Service uninstalled successfully!"
}

# Function to perform the actual sync
do_sync() {
    # Create local directory
    mkdir -p "$LOCAL_DIR"

    # Sync folders
    log_message "Syncing danastro folder..."
    rsync -avz --progress "$REMOTE:/mnt/d/danastro/" "$LOCAL_DIR/danastro/"

    log_message "Syncing Astrophotography folder..."
    rsync -avz --progress "$REMOTE:/mnt/d/Astrophotography/" "$LOCAL_DIR/Astrophotography/"

    log_message "Sync complete!"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  (no args)         Run sync normally (ignores power status)"
    echo "  --cron            Run only if on AC power (for scheduled execution)"
    echo "  --cron-install    Install as hourly scheduled service"
    echo "  --cron-uninstall  Remove scheduled service"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run sync now"
    echo "  $0 --cron-install     # Set up hourly sync when on power"
    echo "  $0 --cron-uninstall   # Remove scheduled sync"
}

# Main script logic
case "${1:-}" in
    "--cron")
        log_message "Running in cron mode, checking power status..."

        if ! is_on_ac_power; then
            log_message "On battery power, exiting without sync"
            exit 0
        fi

        log_message "On AC power, proceeding with sync..."
        do_sync
        ;;
    "--cron-install")
        install_cron_service
        ;;
    "--cron-uninstall")
        uninstall_cron_service
        ;;
    "--help")
        show_usage
        ;;
    "")
        # No arguments, run sync normally
        log_message "Running sync..."
        do_sync
        ;;
    *)
        echo "❌ Error: Unknown option '$1'"
        echo ""
        show_usage
        exit 1
        ;;
esac
