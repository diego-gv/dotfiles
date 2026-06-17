#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
# shellcheck disable=SC1091
source "$ROOT_DIR/core/platform.sh"

if is_docker_environment; then
  echo "⚠️  Docker/container detectado; omitiendo Flameshot."
  exit 0
fi

if command -v flameshot >/dev/null 2>&1; then
  exit 0
fi

sudo apt-get update -y
sudo apt-get install -y flameshot

# Desactiva atajos por defecto de captura en GNOME.
gsettings set org.gnome.shell.keybindings screenshot "@as []"
gsettings set org.gnome.shell.keybindings screenshot-window "@as []"
gsettings set org.gnome.shell.keybindings show-screen-recording-ui "@as []"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "@as []"

# Configura Flameshot en tecla Print.
BASE_SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
BASE_RESOURCE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

if ! gsettings get $BASE_SCHEMA custom-keybindings | grep -q "${BASE_RESOURCE_PATH}/custom0/"; then
  gsettings set $BASE_SCHEMA custom-keybindings "['${BASE_RESOURCE_PATH}/custom0/']"
fi

gsettings set "$BASE_SCHEMA.custom-keybinding:${BASE_RESOURCE_PATH}/custom0/" name "Flameshot"
gsettings set "$BASE_SCHEMA.custom-keybinding:${BASE_RESOURCE_PATH}/custom0/" binding "Print"
gsettings set "$BASE_SCHEMA.custom-keybinding:${BASE_RESOURCE_PATH}/custom0/" command "sh -c 'flameshot gui'"
