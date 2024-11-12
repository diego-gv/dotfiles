#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -a EXTENSIONS=(
    # User Extensions
    "'Bluetooth-Battery-Meter@maniacx.github.com'"
    "'blur-my-shell@aunetx'"
    "'caffeine@patapon.info'"
    "'color-picker@tuberry'"
    "'Hide_Activities@shay.shayel.org'"
    "'impatience@gfxmonk.net'"
    "'mprisLabel@moon-0xff.github.com'"
    "'Resource_Monitor@Ory0n'"
    "'tilingshell@ferrarodomenico.com'"
    # Default Extensions
    "'ding@rastersoft.com'"
    "'ubuntu-appindicators@ubuntu.com'"
    "'ubuntu-dock@ubuntu.com'"
    "'tiling-assistant@ubuntu.com'"
)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Extensions\n\n"

execute "gsettings set org.gnome.shell disable-user-extensions false" \
    "Enable user extensions"

execute "gsettings set org.gnome.shell enabled-extensions \"[$(IFS=', '; echo "${EXTENSIONS[*]}")]\"" \
    "Enable extensions"

