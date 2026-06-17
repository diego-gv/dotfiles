#!/usr/bin/env zsh
# vim: set filetype=zsh

docker() {
    if [[ "$1" == "ps" ]]; then
        shift

        local include_all="false"
        local -a forwarded_args
        forwarded_args=()

        for arg in "$@"; do
            if [[ "$arg" == "-a" || "$arg" == "--all" ]]; then
                include_all="true"
            else
                forwarded_args+=("$arg")
            fi
        done

        if [[ "$include_all" == "true" ]]; then
            command docker ps -a "${forwarded_args[@]}" --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
        else
            command docker ps "${forwarded_args[@]}" --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
        fi

        return $?
    fi

    command docker "$@"
}
