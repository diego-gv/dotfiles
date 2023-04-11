#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

STARSHIP="usr/local/bin"

do_install() {
	if [[ -e "${STARSHIP}/starship" ]]; then
		info "[starship] Already installed"
		return
	fi

	info "[starship] Install"
	sudo curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
}

do_configure() {
	info "[starship] Configure"
	info "[starship][configure] Create config file symlink"
	mkdir -p $XDG_CONFIG_HOME/starship
	ln -fs "${DOTFILES_DIR}/starship/starship.toml" "${XDG_CONFIG_HOME}/starship/starship.toml"
}

main() {
	command=$1
	case $command in
	"install")
		shift
		do_install "$@"
		;;
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
