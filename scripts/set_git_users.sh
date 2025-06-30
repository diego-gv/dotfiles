#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update_gitconfig() {
    local file="$HOME/.dotfiles/src/git/gitconfig.$1"

    ask "Enter git username for $1 configuration: "
    username=$(get_answer)
    ask "Enter git email for $1 configuration: "
    email=$(get_answer)

    sed -i "s/name = .*/name = $username/" "$file"
    sed -i "s/email = .*/email = $email/" "$file"
}

ignore_gitconfig_changes() {
    git update-index --assume-unchanged $HOME/.dotfiles/src/git/gitconfig.personal
    git update-index --assume-unchanged $HOME/.dotfiles/src/git/gitconfig.workspace
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "\n • Setup Git users\n\n"
    update_gitconfig "personal"
    update_gitconfig "workspace"
    ignore_gitconfig_changes
}

main
