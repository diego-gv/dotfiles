#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-git@github.com:diego-gv/dotfiles.git}"

if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: git no está disponible; no se puede configurar origin." >&2
    exit 1
fi

cd "$ROOT_DIR"

git_safe() {
    git -c safe.directory="$ROOT_DIR" "$@"
}

if [[ -d "$ROOT_DIR/.git" ]]; then
    if git_safe remote get-url origin >/dev/null 2>&1; then
        echo "INFO: origin ya está configurado; no se requieren cambios."
        exit 0
    fi

    git_safe remote add origin "$DOTFILES_REPO_URL"
    exit 0
fi

git init >/dev/null 2>&1
git_safe remote add origin "$DOTFILES_REPO_URL"

git_safe remote get-url origin >/dev/null 2>&1
