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
./installs/website.sh
# ./installs/tokyo-night-storm.sh

# Clean up.
rm -rf "$tmpDir"
