#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Extensions\n\n"

execute "gsettings set org.gnome.shell disable-user-extensions false" \
    "Enable user extensions"

execute "gsettings set org.gnome.shell enabled-extensions \"[$(IFS=', '; echo "${EXTENSIONS[*]}")]\"" \
    "Enable extensions"

