#!/usr/bin/env bash

ensure_safe_symlink() {
    local source_path="$1"
    local target_path="$2"

    if [[ -L "$target_path" ]]; then
        if [[ "$(readlink "$target_path")" == "$source_path" ]]; then
            return 0
        fi

        rm -f "$target_path"
    elif [[ -e "$target_path" ]]; then
        mv -f "$target_path" "$target_path.bak.$(date +%s)"
    fi

    ln -s "$source_path" "$target_path"
}
