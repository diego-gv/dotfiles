#!/usr/bin/env zsh
# vim: set filetype=zsh

# misc
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

alias grepi="grep -i"
alias up="${HOME}/dotfiles/scripts/update.sh"

# git
# alias ggrep="git grep -n -I --break --heading -B0 -A0"
# alias ggrepi="ggrep --ignore-case"
# alias gu="git stash && git pull && git stash pop || true"

# docker
docker-clean() {
    docker container prune -f && docker volume prune -f && docker network prune -f
}

# tldr
# npm install -g tldr
# alias tldr="tldr --theme=base16"

# z with fzf
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')" || return
}
