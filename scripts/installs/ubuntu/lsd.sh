#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r os_version="$(get_os_version)"
declare -r MINIMUM_UBUNTU_VERSION="23.04"
declare -r LSD_VERSION="${LSD_VERSION:=1.1.5}"
declare -r LSD_PACKAGE_URL="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd_${LSD_VERSION}_amd64.deb"

install_binary() {

    if [[ ! "$(lsd --version 2>/dev/null)" == *"${LSD_VERSION}"* ]]; then

        local -r TMP_FILE="$(mktemp /tmp/XXXX.deb)"
    
        curl \
            --location \
            --silent \
            --show-error \
            --output "$TMP_FILE" \
            "$LSD_PACKAGE_URL" \
                &> /dev/null
                
        sudo dpkg -i "${TMP_FILE}" &> /dev/null

    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if is_supported_version "$os_version" "$MINIMUM_UBUNTU_VERSION"; then
    install_package "LSD" "lsd"
else
    execute install_binary "LSD" 
fi
