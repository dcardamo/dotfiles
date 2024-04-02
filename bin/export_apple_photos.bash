#!/bin/bash

# Exporting to lightroom
# Notes:
#

#export EXPORT_TO="/Volumes/BackupDrive/osxphotos"
export EXPORT_TO="/Volumes/BackupDrive/osxphotos"
export LIBRARY_AT="/Volumes/ApplePhotos/Photos Library.photoslibrary"

osxphotos export "$EXPORT_TO" \
    --library "$LIBRARY_AT" \
    --download-missing  \
    --exiftool \
    --sidecar xmp \
    --keyword-template "PhotosExport>{folder_album(>)}" \
    --keyword-template "{edited?edited-before-lightroom,}" \
    --directory "{created.year}/{created.month}" \
    --update  #uncomment if running again.
    #--export-by-date  \
