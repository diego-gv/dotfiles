#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_repository() {
    if ! package_is_installed "code"; then
        echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
        add_key https://packages.microsoft.com/keys/microsoft.asc
        add_repo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    fi
}


install_plugin() {
    execute "code --install-extension $2" "$1 plugin"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install VSCode
execute "add_repository" "Add repository"
install_package "Install" "code"
install_package "Install (insiders)" "code-insiders"
