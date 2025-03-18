#!/bin/bash

# Set DRYRUN to 1 for a dry run, 0 for actual execution
DRYRUN=0

# Set source and destination directories
SRC=~/Sync/Photos/originals/
DEST=~/Sync/Photos/published/

# Create a temporary file for the file list
FILELIST=$(mktemp)

# Generate a list of files with case-insensitive extensions, relative to $SRC
cd "$SRC" || exit 1  # Change to source directory, exit if failed
find . -type f | awk 'tolower($0) ~ /\.(mov|mp4|mpg|avi|mkv)$/ {print substr($0, 3)}' > "$FILELIST"

# Construct the rsync command
RSYNC_CMD="rsync -av --progress --info=stats2 --files-from=\"$FILELIST\" \"$SRC\" \"$DEST\""

# Append --dry-run if DRYRUN is enabled
if [ "$DRYRUN" -eq 1 ]; then
    RSYNC_CMD="$RSYNC_CMD --dry-run"
    echo "Performing a dry run..."
else
    echo "Executing file transfer..."
fi

# Run the command
eval $RSYNC_CMD

# Clean up: Remove the temporary file
rm -f "$FILELIST"
