#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r FONTS_DIR="${HOME}/.local/share/fonts"
declare -rA NERD_FONTS_TO_INSTALL=(
    ["MesloLGS Nerd Font"]="Meslo/S/Regular"
)

font_is_installed() {
    test $(fc-list :family="${1}" | wc -l) -ne 0 &> /dev/null
}

install_nerd_fonts() {

    tmpDir="$(mktemp --directory)"
    git clone --quiet --filter=blob:none --sparse "https://github.com/ryanoasis/nerd-fonts.git" "$tmpDir"
    
    cd "${tmpDir}"
    for i in "${!NERD_FONTS_TO_INSTALL[@]}"; do
		name=${NERD_FONTS_TO_INSTALL[$i]}

        if ! font_is_installed $i; then
            git sparse-checkout add patched-fonts/${name}
            find . -type f -name '*.ttf' ! -name '*Windows*' -exec cp "{}" "${FONTS_DIR}" \;
        fi

    done
    
    fc-cache -fv

}


install_fira_code_iscript() {

    tmpDir="$(mktemp --directory)"
    i="Fira Code iScript"

    if ! font_is_installed $i; then
        git clone --quiet "https://github.com/kencrocken/FiraCodeiScript.git" "$tmpDir"
        cd "${tmpDir}"
        find . -type f -name '*.ttf' ! -name '*Windows*' -exec cp "{}" "${FONTS_DIR}" \;
    fi
    
    fc-cache -fv
    
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   Fonts\n\n"

    execute "install_nerd_fonts" "Nerd Fonts"
    execute "install_fira_code_iscript" "Fira Code iScript"

}

main
