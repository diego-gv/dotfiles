#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Extensions\n\n"

execute "pip3 install gnome-extensions-cli --break-system-packages" \
    "Install 'gnome-extensions-cli' tool"

execute "gnome-extensions-cli install Bluetooth-Battery-Meter@maniacx.github.com" \
    "Install 'Bluetooth Battery Meter' extension"

execute "gnome-extensions-cli install blur-my-shell@aunetx" \
    "Install 'Blur my Shell' extension"

execute "gnome-extensions-cli install caffeine@patapon.info" \
    "Install 'Caffeine' extension"

execute "gnome-extensions-cli install color-picker@tuberry" \
    "Install 'Color Picker' extension"

execute "gnome-extensions-cli install Hide_Activities@shay.shayel.org" \
    "Install 'Hide Activities' extension"

execute "gnome-extensions-cli install impatience@gfxmonk.net" \
    "Install 'Impacience' extension"

execute "gnome-extensions-cli install mediacontrols@cliffniff.github.com" \
    "Install 'Media Controls' extension"

execute "gnome-extensions-cli install Resource_Monitor@Ory0n" \
    "Install 'Resource Monitor' extension"

execute "gnome-extensions-cli install tilingshell@ferrarodomenico.com" \
    "Install 'Tiling Shell' extension"
