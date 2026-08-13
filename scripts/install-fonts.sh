#!/usr/bin/env bash
set -euo pipefail

FONTS_DIR="${HOME}/.local/share/fonts"

if ! command -v fc-list >/dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install -y fontconfig
fi

install_font_repo() {
    local display_name="$1"
    local repo_url="$2"
    local sparse_path="${3:-}"
    local tmpdir

    if fc-list | grep -qi -- "$display_name"; then
        return 0
    fi

    tmpdir=$(mktemp -d /tmp/font-install.XXXXXX)

    git clone --depth 1 --filter=blob:none --sparse "$repo_url" "$tmpdir" >/dev/null 2>&1

    if [[ -n "$sparse_path" ]]; then
        git -C "$tmpdir" sparse-checkout set "$sparse_path"
    fi

    find "$tmpdir" -type f \( -iname '*.ttf' -o -iname '*.otf' \) ! -name '*Windows*' -exec cp -f {} "$FONTS_DIR" \;

    rm -rf "$tmpdir"
}

install_font_repo "MesloLGS Nerd Font" "https://github.com/ryanoasis/nerd-fonts.git" "patched-fonts/Meslo/S/Regular"
install_font_repo "Fira Code iScript" "https://github.com/kencrocken/FiraCodeiScript.git"
install_font_repo "Monaspace" "https://github.com/githubnext/monaspace.git" "fonts"

if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -fv
fi
