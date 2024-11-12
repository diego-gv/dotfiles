#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -a DOCK_APPS=(
    "'brave-browser.desktop'"
    "'org.gnome.Nautilus.desktop'"
    "'org.gnome.Terminal.desktop'"
    "'code.desktop'"
    "'postman.desktop'"
    "'dbeaver-ce.desktop'"
    "'org.gnome.Settings.desktop'"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Interface\n\n"

# execute "gsettings set org.gnome.desktop.interface show-battery-percentage true" \
#     "Show Battery Percentage"

execute "gsettings set org.gnome.shell favorite-apps \"[$(IFS=', '; echo "${DOCK_APPS[*]}")]\"" \
    "Configure dock applications"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'" \
    "Set dock location (BOTTOM)"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24" \
    "Set dock icon size (24)"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts true" \
    "Hide mounts in dock"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted false" \
    "Hide mounted mounts in dock"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-network true" \
    "Show networks mounts in dock"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true" \
    "Show trash in dock"

