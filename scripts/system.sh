#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

FONTS_DIR="$HOME/.local/share/fonts"

do_install() {
	local packages=(
		build-essential
		cmake
		curl
		fontconfig
		git
		htop
		vim
		wget
		zsh
	)

	info "[system] Install packages"
	export DEBIAN_FRONTEND=noninteractive
	sudo apt-add-repository -y ppa:git-core/ppa
	sudo apt-get update -qq
	sudo apt-get install -qq -y "${packages[@]}"
}

do_configure() {
	info "[system] Configure"
	info "[system][configure] Create directories"
	info "[system][configure][directories] Repositories"
	sudo install -d -m 0755 -o "${USER}" -g "${USER}" /repos

	info "[system][configure][directories] Workspace"
	install -d -m 0755 -o "${USER}" -g "${USER}" "$HOME/workspace"

	info "[system][configure][directories] User Fonts"
	install -d -m 0755 -o "${USER}" -g "${USER}" "${FONTS_DIR}"

	info "[system][configure][directories] User binaries"
	install -d -m 0755 -o "${USER}" -g "${USER}" "$HOME/bin"

	# Font: MesloLGL Nerd Font Mono
	# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/L/Regular/complete
	info "[system][configure] Install patched fonts"
	local install_dir="/tmp/nerd-fonts"
	rm -rf "${install_dir}" && mkdir -p "${install_dir}"
	git clone --quiet --filter=blob:none --sparse "https://github.com/ryanoasis/nerd-fonts.git" "${install_dir}"
	(
		cd "${install_dir}"
		git sparse-checkout add patched-fonts/Meslo/S/Regular
		find . -type f -name '*.ttf' ! -name '*Windows*' -exec cp "{}" "${FONTS_DIR}" \;
	)
	sudo fc-cache -f
}

do_reboot() {
	info "[system] Reboot"
	while true; do
		read -p "[system][reboot] Do you want to reboot the system to apply all changes? [Y/n] " action
		action=${action:-Y}
		case $action in
			[Yy]* ) reboot ;;
			[Nn]* ) warn "[system][reboot] Some changes will not be applied until the system is restarted" ; exit ;;
			* ) warn "[system][reboot] Please answer yes or no" ;;
		esac
	done

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
	"reboot")
		shift
		do_reboot "$@"
		;;
	*)
		error "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
