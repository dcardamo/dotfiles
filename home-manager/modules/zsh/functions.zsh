#!/usr/bin/env zsh
# Shell functions - sources all individual function files

# Get the directory where this script is located
local functions_dir="${0:A:h}/functions"

# Source all function files
for func_file in "$functions_dir"/*; do
    if [[ -f "$func_file" ]]; then
        source "$func_file"
    fi
done