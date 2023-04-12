#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

# Font: MesloLGL Nerd Font Mono
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/L/Regular/complete

TARGET_THEME="tokyo-night-storm"
TARGET_FONT="MesloLGS Nerd Font Mono"
TARGET_FONT_SIZE="10"

do_configure() {
	info "[gnome-terminal] Configure"

	if is_docker; then
		warn "[gnome-terminal][configure] I'm inside matrix 😭" && return
	fi

	export TERMINAL=gnome-terminal
	local install_dir="/tmp/gogh"

	info "[gnome-terminal][configure] Configure profile"
	dconf load /org/gnome/terminal/legacy/profiles:/:default/ < $DOTFILES_DIR/gnome-terminal/default.dconf

	info "[gnome-terminal][configure] Configure themes"
	rm -rf "$install_dir" && mkdir -p "$install_dir"
	git clone --quiet https://github.com/Mayccoll/Gogh.git "$install_dir"

	info "[gnome-terminal][configure][themes] $TARGET_THEME"
	bash "/tmp/gogh/installs/tokyo-night-storm.sh"
	
	# dconf reset -f /org/gnome/terminal/
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
