#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_symlink() {

    # Create a symlink to preserve monitor configuration on the login screen
    execute \
        "sudo ln -fs ${HOME}/.config/monitors.xml /var/lib/gdm3/.config/monitors.xml" \
        "Create symlink"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Monitors\n\n"

create_symlink
