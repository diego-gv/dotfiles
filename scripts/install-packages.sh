#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
source "$ROOT_DIR/core/symlink.sh"

CORE_PACKAGES=(
  apt-transport-https
  ca-certificates
  build-essential
  curl
  git
  gnupg
  lsb-release
  software-properties-common
  bat
  btop
  fastfetch
  fzf
  vim
  wget
  xclip
  fontconfig
)

# apt-get install es idempotente: paquetes ya instalados se omiten.
sudo apt-get update -y
sudo apt-get install -y "${CORE_PACKAGES[@]}"

# En Debian/Ubuntu paquete se llama bat, binario suele quedar como batcat.
if [ ! -x "/usr/bin/bat" ] && [ -x "/usr/bin/batcat" ]; then
  mkdir -p "$HOME/.local/bin"
  ensure_safe_symlink "/usr/bin/batcat" "$HOME/.local/bin/bat"
fi
