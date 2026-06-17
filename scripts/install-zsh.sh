#!/usr/bin/env bash
set -euo pipefail

if command -v zsh >/dev/null 2>&1 && [ -d "$HOME/.config/oh-my-zsh" ]; then
	exit 0
fi

sudo apt-get update -y
sudo apt-get install -y zsh

if [ ! -d "$HOME/.config/oh-my-zsh" ]; then
	ZSH="$HOME/.config/oh-my-zsh" RUNZSH=no CHSH=no sh -c "$(curl -fL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended
fi
