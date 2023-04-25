#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

BACKUP_DIR="/home/.backup"
WORKSPACE_DIR="$HOME/workspace"
PERSONAL_DIR="$HOME/personal"
FONTS_DIR="$HOME/.local/share/fonts"
USER_BINARIES="$HOME/bin"

do_install() {
	local packages=(
		build-essential
		cmake
		curl
		fontconfig
		alacritty
		git
		htop
		vim
		wget
		zsh
	)

	info "[system] Install packages"
	export DEBIAN_FRONTEND=noninteractive
	sudo apt-add-repository -y ppa:git-core/ppa	# git repository
	sudo add-apt-repository -y ppa:aslatter/ppa # alacritty repository
	sudo apt-get update -qq
	sudo apt-get install -qq -y "${packages[@]}"
}

do_configure() {
	info "[system] Configure"
	info "[system][configure] Create directories"
	info "[system][configure][directories] Workspace"
	sudo install -d -m 0755 -o "${USER}" -g "${USER}" "${WORKSPACE_DIR}"

	info "[system][configure][directories] Personal"
	install -d -m 0755 -o "${USER}" -g "${USER}" "${PERSONAL_DIR}"

	info "[system][configure][directories] User Fonts"
	install -d -m 0755 -o "${USER}" -g "${USER}" "${FONTS_DIR}"

	info "[system][configure][directories] User binaries"
	install -d -m 0755 -o "${USER}" -g "${USER}" "${USER_BINARIES}"

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

do_backup() {
	info "[system] Create backup"
	info "[system][backup] Backup directory in ${BACKUP_DIR}"
	sudo install -d -m 0755 -o "${USER}" -g "${USER}" "${BACKUP_DIR}"
	info "[system][backup] Copying files from $HOME to $BACKUP_DIR"
	rsync -arv "$HOME/" "$BACKUP_DIR/" --include-from="${DOTFILES_DIR}/backup/files.include" --exclude-from="${DOTFILES_DIR}/backup/files.exclude" 
}

do_restore() {
	info "[system] Restore backup"
	sudo rsync -arv "$BACKUP_DIR/" "$HOME/"
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
	"backup")
		shift
		do_backup "$@"
		;;
	"restore")
		shift
		do_restore "$@"
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
