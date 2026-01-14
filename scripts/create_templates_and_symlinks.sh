#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_templates() {

    declare -rA TEMPLATES_TO_COPY=(
        ["secrets/common.template"]="${HOME}/.secrets/common"
        ["ssh/config.template"]="${HOME}/.ssh/config"
    )

    local i=""
    local sourceFile=""
    local targetFile=""
    local targetDir=""
    local skipQuestions=false

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$@" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in "${!TEMPLATES_TO_COPY[@]}"; do

        sourceFile="$(cd .. && pwd)/src/$i"
        targetFile="${TEMPLATES_TO_COPY[$i]}"
        targetDir="$(dirname "$targetFile")"

        if [ ! -e "$targetDir" ] ; then

            mkdir -p "$targetDir"

        fi

        if [ -e "$targetFile" ] && ! $skipQuestions; then

            ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
            if ! answer_is_yes; then
                continue
            fi

        fi

        execute \
            "cp -a '$sourceFile' '$targetFile'" \
            "$sourceFile → $targetFile"

    done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_symlinks() {

    declare -rA TEMPLATES_TO_COPY=(
        ["secrets/common.template"]="${HOME}/.secrets/common"
        ["ssh/config.template"]="${HOME}/.ssh/config"
    )

    local i=""
    local targetFile=""
    local symlinkFile=""

    for i in "${!TEMPLATES_TO_COPY[@]}"; do
        targetFile="${TEMPLATES_TO_COPY[$i]}"
        symlinkFile="$(cd .. && pwd)/src/${i%.template}"

        if [ -L "$symlinkFile" ] && \
           [ "$(readlink -f "$symlinkFile")" == "$(readlink -f "$targetFile")" ]; then
            continue
        fi

        execute \
            "sudo ln -sfn '$targetFile' '$symlinkFile'" \
            "(reverse symlink) $symlinkFile → $targetFile"
    done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "\n • Create templates (copy)\n\n"
    create_templates "$@"
    create_symlinks "$@"
}

main "$@"
