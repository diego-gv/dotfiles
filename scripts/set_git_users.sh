#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update_gitconfig() {
    local file="$HOME/.dotfiles/src/git/gitconfig.$1"
    local name email

    name=$(grep '^\s*name = ' "$file" | awk -F'= ' '{print $2}')
    email=$(grep '^\s*email = ' "$file" | awk -F'= ' '{print $2}')

    ask "Enter git username for $1 configuration [$name]: "
    new_name=$(get_answer)
    ask "Enter git email for $1 configuration [$email]: "
    new_email=$(get_answer)

    sed -i "s/^\s*name = .*/	name = ${new_name:-$name}/" "$file"
    sed -i "s/^\s*email = .*/	email = ${new_email:-$email}/" "$file"
}

ignore_gitconfig_changes() {

    git update-index --assume-unchanged $HOME/.dotfiles/src/git/gitconfig.personal
    git update-index --assume-unchanged $HOME/.dotfiles/src/git/gitconfig.workspace

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "\n • Setup Git users\n\n"

    # Remove/ignore tracking changes
    ignore_gitconfig_changes

    ask_for_confirmation "Do you want to configure git users?"

    if answer_is_yes; then

        update_gitconfig "personal"
        update_gitconfig "workspace"

    fi


}

main
