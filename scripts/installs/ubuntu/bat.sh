#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


create_symlink() {

    # Create symlink required in apt installation

    execute \
        "ln -fs /usr/bin/batcat ${HOME}/.local/bin/bat" \
        "BAT (symlink)"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_package "BAT" "bat"
create_symlink
