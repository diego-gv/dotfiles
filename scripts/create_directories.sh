#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


create_directories() {

    declare -a DIRECTORIES_TO_CREATE=(
        "$HOME/workspace"
        "$HOME/personal"
        "$HOME/.config"
        "$HOME/.local/share/fonts"
        "$HOME/.local/bin"
    )

    for name in "${DIRECTORIES_TO_CREATE[@]}"; do
        mkdir -p "$name"
        print_result $? "Create '$name'" "true"
    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Create directories\n\n"
    create_directories

}

main
