#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

download_package() {

    if ! package_is_installed "google-chrome-stable"; then
        wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        update
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Brave
execute "download_package" "Download package"
install_package "Google Chrome" "google-chrome-stable" "/tmp/google-chrome.deb"
