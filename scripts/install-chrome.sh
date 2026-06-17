#!/usr/bin/env bash
set -euo pipefail

if command -v google-chrome-stable >/dev/null 2>&1; then
  exit 0
fi

tmpfile=$(mktemp /tmp/chrome.XXXXXX.deb)
trap 'rm -f "$tmpfile"' EXIT
wget -O "$tmpfile" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i "$tmpfile" || sudo apt-get install -f -y
