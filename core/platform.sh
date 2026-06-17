#!/usr/bin/env bash

detect_platform() {
    DOTFILES_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
    DOTFILES_ARCH="$(uname -m)"

    DOTFILES_DISTRO=""
    DOTFILES_VERSION=""
    DOTFILES_VERSION_ID=""
    # shellcheck disable=SC2034
    DOTFILES_CODENAME=""

    case "$DOTFILES_OS" in
        linux)
            if [[ -r /etc/os-release ]]; then
                # shellcheck disable=SC1091
                source /etc/os-release

                DOTFILES_DISTRO="${ID:-unknown}"
                DOTFILES_VERSION="${VERSION:-unknown}"
                DOTFILES_VERSION_ID="${VERSION_ID:-unknown}"
                DOTFILES_CODENAME="${VERSION_CODENAME:-${UBUNTU_CODENAME:-unknown}}"
            else
                DOTFILES_DISTRO="unknown"
            fi
            ;;

        darwin)
            DOTFILES_DISTRO="macos"
            DOTFILES_VERSION="$(sw_vers -productVersion)"
            DOTFILES_VERSION_ID="$DOTFILES_VERSION"
            # shellcheck disable=SC2034
            DOTFILES_CODENAME="unknown"
            ;;

        *)
            DOTFILES_DISTRO="unknown"
            ;;
    esac
}

require_linux() {
    [[ "${DOTFILES_OS:-}" == "linux" ]] || {
        echo "ERROR: this script only supports Linux"
        exit 1
    }
}

require_distro() {
    local expected="$1"

    [[ "${DOTFILES_DISTRO:-}" == "$expected" ]] || {
        echo "ERROR: unsupported distro: ${DOTFILES_DISTRO:-unknown}. Expected: $expected"
        exit 1
    }
}

require_ubuntu() {
    require_linux
    require_distro "ubuntu"
}

require_ubuntu_version() {
    local expected="$1"

    require_ubuntu

    [[ "${DOTFILES_VERSION_ID:-}" == "$expected" ]] || {
        echo "ERROR: Ubuntu ${DOTFILES_VERSION_ID:-unknown} is not supported. Expected: $expected"
        exit 1
    }
}

is_linux() {
    [[ "${DOTFILES_OS:-}" == "linux" ]]
}

is_macos() {
    [[ "${DOTFILES_OS:-}" == "darwin" ]]
}

is_ubuntu() {
    [[ "${DOTFILES_DISTRO:-}" == "ubuntu" ]]
}

is_debian() {
    [[ "${DOTFILES_DISTRO:-}" == "debian" ]]
}

is_x86_64() {
    [[ "${DOTFILES_ARCH:-}" == "x86_64" ]]
}

is_arm64() {
    [[ "${DOTFILES_ARCH:-}" == "arm64" || "${DOTFILES_ARCH:-}" == "aarch64" ]]
}

is_docker_environment() {
    [[ -f /.dockerenv ]] && return 0

    if [[ -r /proc/1/cgroup ]] && grep -Eq '(docker|containerd|kubepods|podman|lxc)' /proc/1/cgroup 2>/dev/null; then
        return 0
    fi

    return 1
}
