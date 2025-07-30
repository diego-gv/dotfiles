#!/usr/bin/env zsh
# vim: set filetype=zsh
function cmd_path () {
    if [[ ${ZSH_VERSION} ]]; then
        whence -cp "$1" > /dev/null 2>&1
    else  # bash
        type -P "$1" > /dev/null 2>&1
    fi
}

# LSD configuration highlights
if cmd_path lsd; then
    LS_OPTS="--color=always --long --group-dirs first"
    alias ls="lsd ${LS_OPTS}"
    alias lt="ls -t --reverse"
    alias la="ls -a"
else
    LS_OPTS="--color=auto --group-directories-first"
    alias ls="ls ${LS_OPTS}"
    alias lt="ls -ltrh"
    alias la="ls -A"
fi

###########
# ALIASES
###########
alias ll='ls -laht'

# Bat
alias cat='batcat'

# Bashtop
alias top='bashtop'

# Grep
alias grepi="grep -i"

# Update
alias up="${HOME}/.dotfiles/scripts/update.sh"

# Clear RAM cache
alias clear-cache="sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'"
alias clear-ram="sudo sysctl -w vm.drop_caches=3"

