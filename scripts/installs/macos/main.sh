#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./xcode.sh
./homebrew.sh

./essentials.sh

./../fonts.sh

./../vim.sh
./../git.sh
./../terminal.sh

./gpg.sh
./misc.sh

./../docker.sh
./../vscode.sh
./../devtools.sh
./../browsers.sh

./cleanup.sh
