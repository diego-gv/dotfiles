#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_diodon_repository() {

    if ! package_is_installed "diodon"; then
        add_ppa "diodon-team/stable"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Miscellaneous\n\n"

# install_package "VLC" "vlc"
install_package "Flameshot" "flameshot"
install_package "Timeshift" "timeshift"
install_package "Tweaks" "gnome-tweaks"
install_package "Extension Manager" "gnome-shell-extension-manager"

execute "add_diodon_repository" "Diodon (add repository)"
install_package "Diodon" "diodon"
