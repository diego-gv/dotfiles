#!/usr/bin/env bash
# =============================================================================
# Base system preparation
#
# Purpose: prepare a minimal Ubuntu system for later dotfiles installation.
# Dependencies: Ubuntu 26.04 amd64, APT, dpkg, and administrator privileges
# only when package metadata must be refreshed or packages installed.
# Side effects: refreshes local APT package indexes and installs curl and wget
# if either package is absent. It does not configure either tool, modify user
# files, add repositories, or generate persistent project-managed state.
# Internal interface: install or verify; invoked by install.sh, never public.
# =============================================================================
set -Eeuo pipefail

readonly COMPONENT_NAME='base'
readonly EXIT_OPERATIONAL=1
readonly EXIT_USAGE=2
readonly EXIT_PRECONDITION=4
readonly BASE_PACKAGES=(curl wget)

on_error() {
  local line_number="$1"
  trap - ERR
  printf '%s: operation failed at line %s\n' "$COMPONENT_NAME" "$line_number" >&2
  exit "$EXIT_OPERATIONAL"
}

trap 'on_error "$LINENO"' ERR

fail() {
  local exit_code="$1"
  shift
  printf '%s: %s\n' "$COMPONENT_NAME" "$*" >&2
  exit "$exit_code"
}

require_command() {
  local command_name="$1"
  command -v "$command_name" >/dev/null 2>&1 || \
    fail "$EXIT_PRECONDITION" "required command is unavailable: $command_name"
}

require_supported_platform() {
  [[ -r /etc/os-release ]] || \
    fail "$EXIT_PRECONDITION" 'cannot identify the operating system'

  # /etc/os-release is supplied by the target operating system.
  # shellcheck disable=SC1091
  source /etc/os-release

  [[ "${ID:-}" == 'ubuntu' && "${VERSION_ID:-}" == '26.04' ]] || \
    fail "$EXIT_PRECONDITION" 'base installation requires Ubuntu 26.04'
  [[ "$(dpkg --print-architecture)" == 'amd64' ]] || \
    fail "$EXIT_PRECONDITION" 'base installation requires the amd64 architecture'
}

package_is_installed() {
  local package_name="$1"
  [[ "$(dpkg-query --showformat='${db:Status-Status}' --show "$package_name" 2>/dev/null)" == 'installed' ]]
}

run_as_root() {
  if (( EUID == 0 )); then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo -- "$@"
  else
    fail "$EXIT_PRECONDITION" 'administrator privileges are required'
  fi
}

verify() {
  local package_name

  require_command dpkg
  require_command dpkg-query
  require_supported_platform

  for package_name in "${BASE_PACKAGES[@]}"; do
    package_is_installed "$package_name" || \
      fail "$EXIT_OPERATIONAL" "the $package_name package is not installed"
    require_command "$package_name"
  done
}

install() {
  local package_name
  local packages_to_install=()

  require_command apt-get
  require_command dpkg
  require_command dpkg-query
  require_supported_platform

  # Refreshing indexes is deliberate: this is the base profile's only update.
  run_as_root apt-get update

  # Only absent packages are passed to APT, keeping repeated runs idempotent.
  for package_name in "${BASE_PACKAGES[@]}"; do
    if ! package_is_installed "$package_name"; then
      packages_to_install+=("$package_name")
    fi
  done

  if (( ${#packages_to_install[@]} > 0 )); then
    run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install --yes "${packages_to_install[@]}"
  else
    printf '%s: curl and wget are already installed\n' "$COMPONENT_NAME"
  fi

  verify
}

main() {
  if (( $# != 1 )); then
    fail "$EXIT_USAGE" 'usage: base.sh <install|verify>'
  fi

  case "$1" in
    install) install ;;
    verify) verify ;;
    *) fail "$EXIT_USAGE" 'usage: base.sh <install|verify>' ;;
  esac
}

main "$@"
