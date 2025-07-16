#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_pre_commit() {
    if ! cmd_exists "pre-commit"; then
        pipx install pre-commit
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install pip
install_package "PIP3" "python3-pip"

# Install pipx
install_package "pipx" "pipx"

# Install pre-commit
execute "install_pre_commit" "pre-commit"
