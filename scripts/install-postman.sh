#!/usr/bin/env bash
set -euo pipefail

if command -v postman >/dev/null 2>&1 || [ -x "/opt/Postman/Postman" ]; then
  exit 0
fi

# Instalación oficial desde tarball distribuido por Postman.
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
curl -L https://dl.pstmn.io/download/latest/linux64 -o "$tmpdir/postman.tar.gz"
tar -xzf "$tmpdir/postman.tar.gz" -C "$tmpdir"
sudo mv "$tmpdir/Postman" /opt/

echo "[Desktop Entry]
Name=Postman
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" | sudo tee /usr/share/applications/postman.desktop
