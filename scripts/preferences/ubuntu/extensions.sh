#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -a EXTENSIONS=()

while IFS= read -r line || [[ -n "$line" ]]; do
    EXTENSIONS+=("'$line'")
done < "$HOME/.dotfiles/src/extensions/ubuntu.txt"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Extensions\n\n"

execute "gsettings set org.gnome.shell disable-user-extensions false" \
    "Enable user extensions"

execute "gsettings set org.gnome.shell enabled-extensions \"[$(IFS=', '; echo "${EXTENSIONS[*]}")]\"" \
    "Enable extensions"

