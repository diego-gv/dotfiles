#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r BASE_SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
declare -r BASE_RESOURCE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

create_keybindings() {
    n=custom${1}
    name=$2
    binding=$3
    command=$4

    gsettings set $BASE_SCHEMA custom-keybindings "['${BASE_RESOURCE_PATH}/${n}/']"
    gsettings set $BASE_SCHEMA.custom-keybinding:$BASE_RESOURCE_PATH/$n/ name "${name}"
    gsettings set $BASE_SCHEMA.custom-keybinding:$BASE_RESOURCE_PATH/$n/ binding "${binding}"
    gsettings set $BASE_SCHEMA.custom-keybinding:$BASE_RESOURCE_PATH/$n/ command "${command}"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Keybindings\n\n"

execute "create_keybindings 0 Flameshot Print 'sh -c \"flameshot gui\"'" \
    "Flameshot"

# Remove old keybindings
# To find the keybindings, install dconf-editor: `sudo aptitude install dconf-editor`

execute "gsettings set org.gnome.shell.keybindings screenshot '@as []'" \
    "Remove screenshot keybinding"

execute "gsettings set org.gnome.shell.keybindings screenshot-window '@as []'" \
    "Remove screenshot UI"

execute "gsettings set org.gnome.shell.keybindings show-screen-recording-ui '@as []'" \
    "Hide screen recording UI"

execute "gsettings set org.gnome.shell.keybindings show-screenshot-ui '@as []'" \
    "Hide screenshot UI"
