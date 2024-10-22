#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


set_default_zsh() {

    # Set Zsh as default shell

    execute \
        "sudo usermod -s \"$(type -P zsh)\" \"$(whoami)\"" \
        "Set default"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



print_in_purple "\n   Zsh\n\n"

install_package "Install" "zsh"
set_default_zsh
