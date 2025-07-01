#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r ZSH="${HOME}/.oh-my-zsh"
declare -r ZSH_CUSTOM="${ZSH}/custom"
declare -r XDG_CONFIG_HOME="${HOME}/.config"

create_symlinks() {

    declare -rA FILES_TO_SYMLINK=(
        ["zsh/aliases.zsh"]="${ZSH_CUSTOM}/aliases.zsh"
        ["zsh/aliases.zsh"]="${ZSH_CUSTOM}/styles.zsh"
        ["zsh/zshenv"]="${HOME}/.zshenv"
        ["zsh/zshopt"]="${HOME}/.zshopt"
        ["zsh/zshrc"]="${HOME}/.zshrc"
        ["git/gitconfig"]="${HOME}/.gitconfig"
        ["git/gitconfig.personal"]="${HOME}/.gitconfig.personal"
        ["git/gitconfig.workspace"]="${HOME}/.gitconfig.workspace"
        ["starship/starship.toml"]="${XDG_CONFIG_HOME}/starship/starship.toml"
        ["fzf/fzf-preview.zsh"]="${XDG_CONFIG_HOME}/fzf/fzf-preview.sh"
        ["bat/config"]="${XDG_CONFIG_HOME}/bat/config"
        ["ssh/config"]="${HOME}/.ssh/config"
    )

    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=false

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$@" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in "${!FILES_TO_SYMLINK[@]}"; do

        sourceFile="$(cd .. && pwd)/src/$i"
		targetFile=${FILES_TO_SYMLINK[$i]}
        targetDir=$(dirname $targetFile)

        if [ ! -e $targetDir ] ; then

            mkdir -p $targetDir

        fi

        if [ ! -e "$targetFile" ] || $skipQuestions; then

            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"

        elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else

            if ! $skipQuestions; then

                ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then

                    rm -rf "$targetFile"

                    execute \
                        "ln -fs $sourceFile $targetFile" \
                        "$targetFile → $sourceFile"

                else
                    print_error "$targetFile → $sourceFile"
                fi

            fi

        fi
	done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "\n • Create symbolic links\n\n"
    create_symlinks "$@"
}

main "$@"
