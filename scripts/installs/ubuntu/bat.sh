#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


create_symlink() {

    # Create symlink required in apt installation

    if ! file_exists "${HOME}/.local/bin/bat"; then
        execute \
            "ln -s /usr/bin/batcat ${HOME}/.local/bin/bat" \
            "BAT (symlink)"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_package "BAT" "bat"
create_symlink
