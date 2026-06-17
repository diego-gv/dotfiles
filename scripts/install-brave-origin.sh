#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
# shellcheck disable=SC1091
source "$ROOT_DIR/core/platform.sh"

if is_docker_environment; then
  echo "⚠️  Docker/container detectado; omitiendo Brave Origin."
  exit 0
fi

if command -v brave-origin >/dev/null 2>&1 || dpkg -s brave-origin >/dev/null 2>&1; then
  exit 0
fi

sudo apt-get install -y apt-transport-https curl gnupg
# Repositorio oficial de Brave Origin.
sudo curl -fLo /usr/share/keyrings/brave-origin-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-core.asc
echo "deb [signed-by=/usr/share/keyrings/brave-origin-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-origin-release.list
sudo apt-get update -y
sudo apt-get install -y brave-origin
