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

# Dotfiles
dot_files() {
    if command -v code-insiders &>/dev/null; then
        code-insiders ~/.dotfiles
    elif command -v code &>/dev/null; then
        code ~/.dotfiles
    else
        echo -e "\033[0;31mYou need to have code-insiders or code installed to use this alias.\033[0m"
    fi
}

alias dotfiles='dot_files'

# Clear RAM cache
alias clear-cache="sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'"
alias clear-ram="sudo sysctl -w vm.drop_caches=3"

# Git aliases
git_clone() {
    url="$1"
    if echo "$url" | grep -iE "git@github.com:(mapfre-tech|mapfre-lab)/" >/dev/null; then
        url="${url/git@github.com:/git@github.com-mapfre:}"
    fi
    git clone "$url"
}

alias gitclone='git_clone'

git_date() {
    # Pasándole cantidad de horas?/días/semanas/meses cambia la fecha del commit referenciado
    # Rollo: -1H, -8H, -1D, -3D, -2W, -1M
    echo "Implement me!"
}

alias gitdate='git_date'
