#!/usr/bin/env bash

# shellcheck disable=2034
XDG_CONFIG_HOME="${HOME}/.config"

info() {
	printf "\033[36m%s\033[0m\n" "$*" >&2
}

warn() {
	printf "\033[33mWarning: %s\033[0m\n" "$*" >&2
}

error() {
	printf "\033[31mError: %s\033[0m\n" "$*" >&2
	exit 1
}

is_installed() {
	if [[ ${ZSH_VERSION} ]]; then
        whence -cp "$1" > /dev/null 2>&1
    else  # bash
        type -P "$1" > /dev/null 2>&1
    fi
}

is_docker() {
	if [ -f /.dockerenv ]; then
		return 0  # True
	fi
	return 1  # False
}

is_wsl() {
	if [[ "$(uname -r)" == *"WSL"* ]]; then
		return 0 # True
	fi
	return 1
}

download() {
	local src=$1
	local dest=$2
	local opts=(--silent --fail --retry-connrefused --retry 5 --location -H "Accept: application/octet-stream")
	if [ -n "${dest}" ]; then
		opts+=(--create-dirs --output "${dest}")
	fi
	curl "${opts[@]}" "${src}"
}