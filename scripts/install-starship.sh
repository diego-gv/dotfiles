#!/usr/bin/env bash
set -euo pipefail

if command -v starship >/dev/null 2>&1; then
	exit 0
fi

sh -c "$(curl -fL https://starship.rs/install.sh)" -- --yes
