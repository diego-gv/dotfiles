#!/usr/bin/env bash
set -euo pipefail

if command -v code >/dev/null 2>&1; then
  exit 0
fi

tmpfile=$(mktemp /tmp/microsoft.XXXXXX.gpg)
trap 'rm -f "$tmpfile"' EXIT
curl -fL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > "$tmpfile"
sudo install -o root -g root -m 644 "$tmpfile" /usr/share/keyrings/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update -y
sudo apt-get install -y code
