#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DEFAULT_PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
CUSTOM_PROFILE_NAME="Website"

get_profile_id_by_name() {
    local profile_name="$1"
    gsettings get org.gnome.Terminal.ProfilesList list | \
        tr -d "[]'," | tr ' ' '\n' | while read -r profile_id; do
        local name=$(gsettings get "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/" visible-name | tr -d "'")
        if [[ "$name" == "$profile_name" ]]; then
            echo "$profile_id"
            return 0
        fi
    done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Terminal\n\n"

execute "gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS Nerd Font Mono 10'" \
    "Change monospace font"

execute "gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$DEFAULT_PROFILE/ visible-name 'Default'" \
    "Rename default profile"

execute "./set_terminal_theme.sh \"$CUSTOM_PROFILE_NAME\"" \
    "Set custom terminal theme"

execute "gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(get_profile_id_by_name $CUSTOM_PROFILE_NAME)/ default-size-columns 120" \
    "Set default terminal size (120 columns)"

execute "gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(get_profile_id_by_name $CUSTOM_PROFILE_NAME)/ default-size-rows 30" \
    "Set default terminal size (30 rows)"
