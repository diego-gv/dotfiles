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
alias cat='bat'

# Grep
alias grepi="grep -i"

# Update
alias up="${HOME}/dotfiles/scripts/update.sh"

# Workon
__find_work_directory() {
    local target=$1
    find $HOME/workspace $HOME/personal -type d -name $target -print 2>/dev/null
}

workon() {
    local target=$1
    local dest=$(__find_work_directory $target)
    local n_results=$(echo $dest | wc -l)
    local current=$(pwd)

    [ -z $target ] && return

    if [ $n_results -gt 1 ]
    then
        echo "${fg[red]}Too many options:"
        echo "$reset_color$dest"
        echo "${fg[yellow]}Use the ${fg[magenta]}cd ${fg[yellow]}command to go to the chosen directory"
        return
    fi

    [ -z $dest ] && echo "${fg[red]}Working directory ${fg[magenta]}$target ${fg[red]}not found" && return

    [ "$current" = "$dest" ] && echo "${fg[red]}It is already the working directory" && return

    echo "${fg[yellow]}Changing working directory to ${fg[magenta]}$dest"
    cd $dest
}

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
