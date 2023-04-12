#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

do_install() {
	info "[docker] Install"
	info "[docker][install] Install dependences"
	sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -qq -y
	info "[docker][install] Configure docker repository"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	info "[docker][install] Update list packages availables"
	sudo apt-get update -qq
	info "[docker][install] Install docker package"
	apt-cache policy docker-ce
	sudo apt-get install docker-ce -qq -y
}

do_configure() {
	info "[docker] Configure"
	info "[docker][configure] Add user to docker group"
	sudo usermod -aG docker ${USER}
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
