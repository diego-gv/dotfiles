#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

do_configure() {
	info "[alacritty] Configure"
	info "[alacritty][configure] Create config file symlink"
	mkdir -p $XDG_CONFIG_HOME/alacritty
	ln -fs "${DOTFILES_DIR}/alacritty/alacritty.yml" "${XDG_CONFIG_HOME}/alacritty/alacritty.yml"
}

main() {
	command=$1
	case $command in
	"configure")
		shift
		do_configure "$@"
		;;
	*)
		error "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
