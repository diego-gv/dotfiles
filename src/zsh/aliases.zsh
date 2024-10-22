#!/usr/bin/env zsh
# vim: set filetype=zsh
function cmd_path () {
    if [[ ${ZSH_VERSION} ]]; then
        whence -cp "$1" > /dev/null 2>&1
    else  # bash
        type -P "$1" > /dev/null 2>&1
    fi
}

###########
# ALIAS
###########
# LSD
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
alias ll='ls'

# Bat
alias cat='batcat'

# Bashtop
alias top='bashtop'

# Grep
alias grepi="grep -i"

# Update
alias up="${HOME}/.dotfiles/scripts/update.sh"

# Work Aliases
alias dps="docker ps"
alias dsp!="docker system prune -a -f --volumes"
alias dpsi="docker images"

###########
# UNALIAS
###########
# z with fzf
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')" || return
}


# TODO: añadir función para configurar un repositorio en especifico (user e email)