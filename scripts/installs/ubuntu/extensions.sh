#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -a EXTENSIONS=()

while IFS= read -r line || [[ -n "$line" ]]; do
    EXTENSIONS+=("'$line'")
done < "$HOME/.dotfiles/src/extensions/ubuntu.txt"

install_extensions() {

    # Install gnome extensions in list

    for extension in "${EXTENSIONS[@]}"; do
        execute "gnome-extensions-cli install $extension" \
            "Install $extension extension"
    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Extensions\n\n"


execute "pip3 install gnome-extensions-cli --break-system-packages" \
    "Install 'gnome-extensions-cli' tool"

install_extensions
