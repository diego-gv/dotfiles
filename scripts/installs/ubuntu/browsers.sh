#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_repository() {

    if ! package_is_installed "brave-browser"; then
        # add_key "https://download.docker.com/linux/ubuntu/gpg"
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        update
    fi
    
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Docker
execute "add_repository" "Add repository"
install_package "Brave" "brave-browser"
