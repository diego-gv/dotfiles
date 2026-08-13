#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

if [[ ! -f "$HOME/.config/git/users" ]]; then
    cp "$ROOT_DIR/templates/git-users.template" "$HOME/.config/git/users"
fi

if [[ ! -f "$HOME/.secrets/common" ]]; then
    cp "$ROOT_DIR/templates/common.template" "$HOME/.secrets/common"
fi

if [[ ! -f "$HOME/.ssh/config" ]]; then
    cp "$ROOT_DIR/templates/config.template" "$HOME/.ssh/config"
fi
