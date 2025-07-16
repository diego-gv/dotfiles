#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

install_node() {
    if ! cmd_exists "node"; then
        nvm install --lts
    fi
}

install_gitmoji() {
    if ! cmd_exists "gitmoji"; then
        npm install -g gitmoji-cli
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install NVM
execute "install_nvm" "NVM (install)"

# Install Node
execute "install_node" "Node (install)"

# Install gitmoji
execute "install_gitmoji" "gitmoji"
