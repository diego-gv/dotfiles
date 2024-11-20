#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_aptitude
update
upgrade

./build-essentials.sh

./../fonts.sh

./zsh.sh
./../vim.sh
./../git.sh
./../terminal.sh

./misc.sh

./../docker.sh
./../vscode.sh
./../devtools.sh
./../browsers.sh

./extensions.sh

./cleanup.sh
