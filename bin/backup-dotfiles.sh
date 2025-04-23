#!/bin/sh

# this will backup dotfiles that exist to this repo.  Its used when
# an app makes modifications to its own config files rather than
# having nix manage them.

# Navigate to the directory of this script
cd $(dirname $(readlink -f $0))
cd ..

# Zed files
if [ -e "$HOME/.config/zed/settings.json" ]; then
  cp "$HOME/.config/zed/settings.json" "backups/.config/zed/settings.json"
fi
if [ -e "$HOME/.config/zed/keymap.json" ]; then
  cp "$HOME/.config/zed/keymap.json" "backups/.config/zed/keymap.json"
fi

# Cursor files
if [ -e "$HOME/Library/Application Support/Cursor/User/settings.json" ]; then
  cp "$HOME/Library/Application Support/Cursor/User/settings.json"\
      "backups/Library/Application Support/Cursor/User/settings.json"
fi
if [ -e "$HOME/Library/Application Support/Cursor/User/keybindings.json" ]; then
  cp "$HOME/Library/Application Support/Cursor/User/keybindings.json"\
      "backups/Library/Application Support/Cursor/User/keybindings.json"
fi


# Windsurf files
if [ -e "$HOME/Library/Application Support/Windsurf/User/settings.json" ]; then
  cp "$HOME/Library/Application Support/Windsurf/User/settings.json"\
      "backups/Library/Application Support/Windsurf/User/settings.json"
fi
if [ -e "$HOME/Library/Application Support/Windsurf/User/keybindings.json" ]; then
  cp "$HOME/Library/Application Support/Windsurf/User/keybindings.json"\
      "backups/Library/Application Support/Windsurf/User/keybindings.json"
fi
