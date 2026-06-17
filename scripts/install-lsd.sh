#!/usr/bin/env bash
set -euo pipefail

LSD_VERSION="1.1.5"
LSD_PACKAGE_URL="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd_${LSD_VERSION}_amd64.deb"

if command -v lsd &> /dev/null; then
  if lsd --version 2>/dev/null | grep -q "${LSD_VERSION}"; then
    exit 0
  fi
fi

tmpfile=$(mktemp /tmp/lsd.XXXXXX.deb)
trap 'rm -f "$tmpfile"' EXIT
curl -L -o "$tmpfile" "$LSD_PACKAGE_URL"
sudo dpkg -i "$tmpfile" || sudo apt-get install -f -y
