#!/usr/bin/env bash
# =============================================================================
# Ubuntu Docker validation entrypoint
#
# Purpose: verify the public installer in an isolated Ubuntu 26.04 container.
# Dependencies: this checkout mounted read-only at /root/.dotfiles and the base
# profile exposed by install.sh.
# Side effects: confined to the ephemeral container; APT indexes are refreshed
# and curl/wget are installed there. No host or repository files are modified.
# Coverage: invokes the public entry point twice, then verifies both commands.
# =============================================================================
set -Eeuo pipefail

readonly REPO_DIR='/root/.dotfiles'

# Repetition proves that the public installation flow remains safe after the
# required packages have already been installed.
bash "$REPO_DIR/install.sh" --non-interactive --profile base --yes
bash "$REPO_DIR/install.sh" --non-interactive --profile base --yes

command -v curl >/dev/null
command -v wget >/dev/null
curl --version >/dev/null
wget --version >/dev/null
