#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Build Essentials\n\n"

# Install tools for compiling/building software from source.
install_package "Build Essential" "build-essential"

# GnuPG archive keys of the Debian archive.
install_package "GnuPG archive keys" "debian-archive-keyring"

# Install tool for download files
install_package "cURL" "curl"

# Install tool for manage fonts
install_package "fontconfig" "fontconfig"

# Copy data in clipboard
install_package "xclip" "xclip"

# Software which is not included by default
# in Ubuntu due to legal or copyright reasons.
#install_package "Ubuntu Restricted Extras" "ubuntu-restricted-extras"
