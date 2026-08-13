#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

if [[ ! -d "$ROOT_DIR/.git" ]]; then
  echo "No se encontró el repositorio git en $ROOT_DIR."
  exit 1
fi

current_branch="$(git -C "$ROOT_DIR" branch --show-current)"
if [[ -z "$current_branch" ]]; then
  echo "No se puede actualizar en detached HEAD."
  exit 1
fi

echo "==> Actualizando el repositorio con ff-only"
git -C "$ROOT_DIR" fetch --prune origin
git -C "$ROOT_DIR" merge --ff-only "origin/$current_branch"

echo "==> Actualizando el sistema"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y

echo "==> Actualizando herramientas clave"
DOTFILES_FORCE_UPDATE=1 bash "$ROOT_DIR/scripts/install-chrome.sh"
DOTFILES_FORCE_UPDATE=1 bash "$ROOT_DIR/scripts/install-postman.sh"

echo "==> Consolidando cambios con bootstrap"
bash "$ROOT_DIR/bootstrap.sh"
