#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DEFAULT_PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Terminal\n\n"

execute "gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS Nerd Font Mono 10'" \
    "Change monospace font"

execute "gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$DEFAULT_PROFILE/ visible-name 'Default'" \
    "Rename default profile"

execute "./set_terminal_theme.sh" \
    "Set custom terminal theme"
