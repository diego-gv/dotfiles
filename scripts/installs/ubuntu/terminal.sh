#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./bat.sh
./fzf.sh
./lsd.sh
./top.sh
./starship.sh
./../ohmyzsh.sh
