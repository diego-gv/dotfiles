#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

do_configure() {
	info "[gnome-terminal] Configure"

	if is_docker; then
		warn "[gnome-terminal][configure] I'm inside matrix 😭" && return
	fi

	export TERMINAL=gnome-terminal
	local install_dir="/tmp/gogh"
	local theme="tokyo-night-storm"

	info "[gnome-terminal][configure] Configure profile"
	dconf load /org/gnome/terminal/legacy/profiles:/:default/ < $DOTFILES_DIR/gnome-terminal/default.dconf

	info "[gnome-terminal][configure] Configure themes"
	rm -rf "$install_dir" && mkdir -p "$install_dir"
	git clone --quiet https://github.com/Mayccoll/Gogh.git "$install_dir"

	info "[gnome-terminal][configure][themes] $theme"
	bash "/tmp/gogh/installs/tokyo-night-storm.sh"
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
