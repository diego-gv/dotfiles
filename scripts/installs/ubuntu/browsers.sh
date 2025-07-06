#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_binary() {

    if ! package_is_installed "google-chrome-stable"; then

        local -r TMP_FILE="$(mktemp /tmp/XXXX.deb)"
        local -r PACKAGE_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

        wget \
            -O $TMP_FILE \
            $PACKAGE_URL

        sudo dpkg -i "${TMP_FILE}" &> /dev/null
    fi

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Google Chrome
execute install_binary "Google Chrome"
