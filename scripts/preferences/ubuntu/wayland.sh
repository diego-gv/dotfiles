#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r GDM_CONF="/etc/gdm3/custom.conf"

disable_wayland() {

    if grep -q "^#WaylandEnable=false" "$GDM_CONF"; then
        sudo sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' "$GDM_CONF"
    elif grep -q "^WaylandEnable=true" "$GDM_CONF"; then
        sudo sed -i 's/^WaylandEnable=true/WaylandEnable=false/' "$GDM_CONF"
    elif ! grep -q "^WaylandEnable=" "$GDM_CONF"; then
        echo "WaylandEnable=false" | sudo tee -a "$GDM_CONF" >/dev/null
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Wayland\n\n"

execute "disable_wayland" "Disable"
