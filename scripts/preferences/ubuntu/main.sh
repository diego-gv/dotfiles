#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./interface.sh
./extensions.sh
./keybindings.sh
./terminal.sh
./disable_wayland.sh
