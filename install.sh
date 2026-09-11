#!/usr/bin/env bash
# =============================================================================
# Dotfiles installer — public entry point
#
# Purpose: orchestrate the currently available installation profile.
# Dependencies: Bash, scripts/components/base.sh, and the target's APT tools.
# Side effects: delegates to the selected component; the base profile refreshes
# APT package indexes and may install curl and wget. It creates no files in the
# repository and generates no persistent installer state.
# Supported interface: --non-interactive --profile base --yes.
# =============================================================================
set -Eeuo pipefail

readonly INSTALLER_NAME='install'
readonly INSTALLER_VERSION='0.1.0'
readonly EXIT_OPERATIONAL=1
readonly EXIT_USAGE=2

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR

on_error() {
  local line_number="$1"
  trap - ERR
  printf '%s: operation failed at line %s\n' "$INSTALLER_NAME" "$line_number" >&2
  exit "$EXIT_OPERATIONAL"
}

trap 'on_error "$LINENO"' ERR

fail() {
  local exit_code="$1"
  shift
  printf '%s: %s\n' "$INSTALLER_NAME" "$*" >&2
  exit "$exit_code"
}

usage() {
  printf '%s\n' 'usage: install.sh --non-interactive --profile base --yes'
}

run_base_profile() {
  # Components run in their own Bash process so their shell options and errors
  # cannot alter the public installer process.
  bash "$SCRIPT_DIR/scripts/components/base.sh" install
}

main() {
  local non_interactive=false
  local confirmation=false
  local profile=''

  while (( $# > 0 )); do
    case "$1" in
      --non-interactive)
        non_interactive=true
        ;;
      --profile)
        (( $# >= 2 )) || fail "$EXIT_USAGE" '--profile requires a value'
        profile="$2"
        shift
        ;;
      --yes)
        confirmation=true
        ;;
      --help)
        usage
        return
        ;;
      --version)
        printf '%s %s\n' "$INSTALLER_NAME" "$INSTALLER_VERSION"
        return
        ;;
      *)
        fail "$EXIT_USAGE" "unsupported option: $1"
        ;;
    esac
    shift
  done

  "$non_interactive" || fail "$EXIT_USAGE" 'interactive mode is not implemented yet'
  "$confirmation" || fail "$EXIT_USAGE" '--yes is required in non-interactive mode'
  [[ "$profile" == 'base' ]] || fail "$EXIT_USAGE" 'the only available profile is base'

  run_base_profile
}

main "$@"
