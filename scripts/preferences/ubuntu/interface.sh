#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Find apps in /usr/share/applications/ or <snap_app_name>_<snap_app_name>.desktop
declare -a DOCK_APPS=(
    "'google-chrome.desktop'"
    "'org.gnome.Nautilus.desktop'"
    "'org.gnome.Terminal.desktop'"
    "'code.desktop'"
    "'code-insiders.desktop'"
    "'postman.desktop'"
    "'dbeaver-ce.desktop'"
    "'org.gnome.Settings.desktop'"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Interface\n\n"

execute "gsettings set org.gnome.desktop.interface show-battery-percentage true" \
    "Show Battery Percentage"

execute "gsettings set org.gnome.shell favorite-apps \"[$(IFS=', '; echo "${DOCK_APPS[*]}")]\"" \
    "Configure dock applications"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40" \
    "Set dock icon size (40)"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts true" \
    "Hide mounts in dock"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted false" \
    "Hide mounted mounts in dock"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-network true" \
    "Show networks mounts in dock"

execute "gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true" \
    "Show trash in dock"

execute "gsettings set org.gnome.desktop.interface clock-show-seconds true" \
    "Show seconds in clock"

execute "gsettings set org.gnome.desktop.interface clock-show-weekday true" \
    "Show weekday in clock"

# execute "gsettings set org.gnome.desktop.background picture-uri 'file://$HOME/.dotfiles/src/backgrounds/ubuntu.jpg'" \
#     "Set background"
