#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-git@github.com:diego-gv/dotfiles.git}"
DOTFILES_ARCHIVE_URL="${DOTFILES_ARCHIVE_URL:-https://github.com/diego-gv/dotfiles/archive/refs/heads/feature/a-new-hope.tar.gz}"
DOTFILES_TARGET_DIR="${DOTFILES_TARGET_DIR:-$HOME/.dotfiles}"

if [[ -e "$DOTFILES_TARGET_DIR" ]]; then
    printf "ERROR: El directorio destino ya existe: %s\n" "$DOTFILES_TARGET_DIR" >&2
    exit 1
fi

tmp_base_dir="${TMPDIR:-$HOME/.tmp}"
mkdir -p "$tmp_base_dir" 2>/dev/null || tmp_base_dir="$HOME"

stage_dir="$(mktemp -d "${tmp_base_dir}/dotfiles.XXXXXX" 2>/dev/null || mktemp -d "${HOME}/dotfiles.XXXXXX")"
[[ -n "$stage_dir" && -d "$stage_dir" ]] || {
    printf "ERROR: No se pudo crear el directorio temporal de instalación\n" >&2
    exit 1
}

archive_path="$stage_dir/dotfiles.tar.gz"
repo_dir="$stage_dir/repo"

printf "%s\n" "Bootstrap remoto detectado; preparando staging temporal en $stage_dir"

if [[ "$DOTFILES_ARCHIVE_URL" == file://* ]]; then
    cp "${DOTFILES_ARCHIVE_URL#file://}" "$archive_path"
elif command -v curl >/dev/null 2>&1; then
    curl -fsSL "$DOTFILES_ARCHIVE_URL" -o "$archive_path"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$archive_path" "$DOTFILES_ARCHIVE_URL"
else
    printf "ERROR: No se pudo descargar el repositorio desde %s\n" "$DOTFILES_ARCHIVE_URL" >&2
    exit 1
fi

mkdir -p "$repo_dir"

tar --extract --gzip --file "$archive_path" --strip-components 1 --directory "$repo_dir" || {
    printf "ERROR: No se pudo extraer el repositorio descargado\n" >&2
    exit 1
}

[[ -f "$repo_dir/bootstrap.sh" ]] || {
    printf "ERROR: No se encontró bootstrap.sh en el repositorio descargado\n" >&2
    exit 1
}

exec env \
    DOTFILES_STAGE_DIR="$stage_dir" \
    DOTFILES_TARGET_DIR="$DOTFILES_TARGET_DIR" \
    DOTFILES_REPO_URL="$DOTFILES_REPO_URL" \
    DOTFILES_ARCHIVE_URL="$DOTFILES_ARCHIVE_URL" \
    bash "$repo_dir/bootstrap.sh"
