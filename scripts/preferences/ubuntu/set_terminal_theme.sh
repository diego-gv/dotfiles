#!/bin/bash

set -e

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare tmpDir="$(mktemp --directory)"

# Use external script to set the color set.
git clone https://github.com/Gogh-Co/Gogh.git "$tmpDir"
cd "$tmpDir"

# necessary in the Gnome terminal on ubuntu
export TERMINAL=gnome-terminal

# Run script to install theme
script_path="./installs/$(echo "${1:-Website}" | tr '[:upper:]' '[:lower:]' | tr ' ' '-').sh"
bash "$script_path"

# Clean up.
rm -rf "$tmpDir"
