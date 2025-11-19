#!/usr/bin/env zsh
# vim: set filetype=zsh

# Colores
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

docker() {

  if [[ "$1" == "ps" ]]; then
    command docker ps --format "{{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}" | \
    awk -F'\t' -v green="$GREEN" -v yellow="$YELLOW" -v red="$RED" -v blue="$BLUE" -v nc="$NC" '
      NR==1 {
        printf "%s%s%s\t%s%s%s\t%s%s%s\t%s%s%s\t%s%s%s\n", blue, "CONTAINER ID", nc, blue, "IMAGE", nc, blue, "NAMES", nc, blue, "STATUS", nc, blue, "PORTS", nc
        next
      }
      {
        id=$1; image=$2; name=$3; status=$4; ports=$5
        emoji=""; color=nc
        if (status ~ /^Up/)          { emoji="✅"; color=green }
        else if (status ~ /^Exited/) { emoji="❌"; color=red }
        else if (status ~ /^Paused/) { emoji="⏸️"; color=yellow }
        status_colored=color emoji " " status nc
        n=split(ports, port_arr, ",")
        for (i=1; i<=n; i++) {
          gsub(/^ +| +$/, "", port_arr[i])
          if (i==1) { printf "%s\t%s\t%s\t%s\t%s\n", id, image, name, status_colored, port_arr[i] }
          else      { printf "%s\t%s\t%s\t%s\t%s\n", "", "", "", "", port_arr[i] }
        }
      }
    ' | column -t -s $'\t'
    return 0
  fi

  # Todos los demás comandos Docker
  command docker "$@"
}
