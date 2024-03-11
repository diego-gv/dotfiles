#!/usr/bin/env bash

set -e

DOTFILES_DIR="${DOTFILES_DIR:=${PWD}}"
# shellcheck disable=SC1090
source "${DOTFILES_DIR}/scripts/util.sh"

COMPOSE_VERSION="${COMPOSE_VERSION:=v2.24.7}"

do_install() {
	if [[ "$(docker compose --version 2>/dev/null)" == *"${COMPOSE_VERSION}"* ]]; then
		info "[docker-compose] ${COMPOSE_VERSION} already installed"
		return
	fi

	info "[docker-compose] Install"
	mkdir -p ~/.docker/cli-plugins/
	curl -SL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
}

do_configure() {
	info "[docker-compose] Configure"
	chmod +x ~/.docker/cli-plugins/docker-compose
	docker compose version
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
