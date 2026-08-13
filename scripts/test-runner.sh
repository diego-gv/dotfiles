#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

source "$ROOT_DIR/core/config.sh"
source "$ROOT_DIR/core/output.sh"
source "$ROOT_DIR/core/runner.sh"

DOTFILES_TOTAL_STEPS=7
DOTFILES_CURRENT_STEP=0

run_with_preview "apt update" "APT: package refresh"
run_with_preview "apt upgrade -y" "APT: system upgrade"
run_with_preview 'echo "stdout"; echo "stderr" >&2; sleep 1; echo "done"' "Test: stdout/stderr"
# shellcheck disable=SC2016
run_with_preview 'for i in {1..20}; do echo "Processing line $i"; sleep 0.1; done' "Test: successful output"
# shellcheck disable=SC2016
run_with_preview 'for i in {1..30}; do echo "$(date +%H:%M:%S) INFO item $i"; sleep 0.1; done' "Test: execution logs"
# shellcheck disable=SC2016
run_with_preview 'for i in {1..20}; do echo "Processing error $i"; sleep 0.1; done; exit 1' "Test: failing output"
