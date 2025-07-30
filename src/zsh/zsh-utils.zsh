#!/usr/bin/env zsh
# vim: set filetype=zsh

function dotfiles() {
    if command -v code-insiders &>/dev/null; then
        code-insiders ~/.dotfiles
    elif command -v code &>/dev/null; then
        code ~/.dotfiles
    else
        echo -e "\033[0;31mYou need to have code-insiders or code installed to use this alias.\033[0m"
    fi
}
