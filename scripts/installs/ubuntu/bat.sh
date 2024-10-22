#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


create_symlink() {

    # Create symlink required in apt installation

    execute \
        "ln -s /usr/bin/batcat ~/.local/bin/bat" \
        "Create symlink for apt installation"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_package "BAT" "bat"
# create_symlink
