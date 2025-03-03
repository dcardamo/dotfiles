#!/bin/bash

# Copy all movie files from originals to processed using rsync
rsync -av \
   --progress --info=stats2 \
   --include='*/' \
   --include='*.mov' \
   --include='*.mp4' \
   --include='*.mpg' \
   --include='*.avi' \
   --include='*.mkv' \
   --exclude='*' \
   ~/Sync/Photos/originals/ \
   ~/Pictures/LRC_EXPORT/
   # TODO:  switch to this soon
   # ~/Sync/Photos/processed/
