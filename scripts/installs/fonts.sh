#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r FONTS_DIR="${HOME}/.local/share/fonts"
declare -rA NERD_FONTS_TO_INSTALL=(
    ["MesloLGS Nerd Font"]="Meslo/S/Regular"
)

font_is_installed() {
    test $(fc-list | grep -i "$1" | wc -l) -ne 0 &> /dev/null
}

install_nerd_fonts() {

    tmpDir="$(mktemp --directory)"
    local need_install=false

    # Check if any font is not installed
    for i in "${!NERD_FONTS_TO_INSTALL[@]}"; do
        if ! font_is_installed "$i"; then
            need_install=true
            break
        fi
    done

    # If all fonts are installed, exit
    if [ "$need_install" = false ]; then
        return
    fi

    # Clone the repo only if it does not exist
    if [ ! -d "$repo_dir" ]; then
        git clone --quiet --filter=blob:none --sparse "https://github.com/ryanoasis/nerd-fonts.git" "$repo_dir"
    fi

    cd "${tmpDir}"
    for i in "${!NERD_FONTS_TO_INSTALL[@]}"; do
		name=${NERD_FONTS_TO_INSTALL[$i]}

        if ! font_is_installed "$i"; then
            git sparse-checkout add patched-fonts/${name}
            find . -type f -name '*.ttf' ! -name '*Windows*' -exec cp "{}" "${FONTS_DIR}" \;
        fi

    done

}


install_fira_code_iscript() {

    tmpDir="$(mktemp --directory)"
    i="Fira Code iScript"

    if ! font_is_installed "$i"; then
        git clone --quiet "https://github.com/kencrocken/FiraCodeiScript.git" "$tmpDir"
        cd "${tmpDir}"
        find . -type f -name '*.ttf' ! -name '*Windows*' -exec cp "{}" "${FONTS_DIR}" \;
    fi

}

install_monaspace_fonts() {

    tmpDir="$(mktemp --directory)"
    i="Monaspace"

    if ! font_is_installed "$i"; then
        git clone --quiet "https://github.com/githubnext/monaspace.git" "$tmpDir"
        cd "${tmpDir}"
        find . -type f -name '*.ttf' ! -name '*Windows*' -exec cp "{}" "${FONTS_DIR}" \;
    fi

}

update_cache_fonts() {

    if command -v fc-cache &> /dev/null; then
        fc-cache -fv
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   Fonts\n\n"

    execute "install_nerd_fonts" "Nerd Fonts"
    execute "install_fira_code_iscript" "Fira Code iScript"
    execute "install_monaspace_fonts" "Monaspace Fonts"
    execute "update_cache_fonts" "Update cache fonts"
}

main
