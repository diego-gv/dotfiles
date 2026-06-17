#!/usr/bin/env zsh
# vim: set filetype=zsh

dotfiles() {
    if command -v code &>/dev/null; then
        code ~/.dotfiles
    else
        echo "You need Visual Studio Code installed to use this command."
        return 1
    fi
}
