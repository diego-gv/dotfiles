#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_repository() {

    if ! package_is_installed "docker-ce"; then
        # add_key "https://download.docker.com/linux/ubuntu/gpg"
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
        add_repo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        add_cache policy docker-ce
    fi

}


set_non_root_user() {

    # Execute docker without root privileges

    execute \
        "sudo usermod -aG docker \"$(whoami)\"" \
        "Set Non-root user"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Docker
execute "add_repository" "Add repository"
install_package "Install" "docker-ce"
set_non_root_user

# Install Docker Compose
# Already installed with docker-ce, but package name is docker-compose-plugin
# install_package "Install" "docker-compose-plugin"
