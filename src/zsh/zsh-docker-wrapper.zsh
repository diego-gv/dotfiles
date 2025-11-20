#!/usr/bin/env zsh
# vim: set filetype=zsh

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"
FG_ALT="\033[38;5;253m"

_docker_ps() {
    command docker ps --format "{{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}" | \
    awk -F'\t' \
        -v green="$GREEN" -v yellow="$YELLOW" -v red="$RED" \
        -v blue="$BLUE" -v nc="$NC" -v fg_alt="$FG_ALT" '
        BEGIN {
            printf "%sCONTAINER ID\tIMAGE\tNAMES\tSTATUS\tPORTS%s\n", blue, nc
        }
        {
            row++
            id=$1; image=$2; name=$3; status=$4; ports=$5

            emoji=""; color=nc
            if (status ~ /^Up/)          { emoji="✅"; color=green }
            else if (status ~ /^Exited/) { emoji="❌"; color=red }
            else if (status ~ /^Paused/) { emoji="⏸️"; color=yellow }

            status=color emoji " " status nc

            fg = (row % 2 == 1) ? fg_alt : nc

            if (ports == "") ports="-"
            n = split(ports, port_arr, ",")

            for (i=1; i<=n; i++) {
                gsub(/^ +| +$/, "", port_arr[i])
                if (i == 1) {
                    printf "%s%s\t%s\t%s\t%s\t%s%s%s\n", fg, id, image, name, status, fg, port_arr[i], nc
                } else {
                    printf "%s\t%s\t%s\t%s\t%s%s\n", fg, "", "", "", port_arr[i], nc
                }
            }
        }
    ' | column -t -s $'\t'
}

docker() {
    if [[ "$1" == "ps" ]]; then
        _docker_ps "$@"
        return 0

    # Otros comandos de docker se pueden añadir aquí
    # elif [[ "$1" == "stats" ]]; then
    #     _docker_stats "$@"
    #     return 0

    else
        command docker "$@"
    fi
}
