#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/core/config.sh"
source "$ROOT_DIR/core/output.sh"
source "$ROOT_DIR/core/platform.sh"
source "$ROOT_DIR/core/plan.sh"
source "$ROOT_DIR/core/runner.sh"

detect_platform

print_bootstrap_banner
print_platform_summary

require_ubuntu

plan_reset

plan_start_stage "🛠️  Bootstrap / System"
plan_add_step "Provisionar" "Paquetes base del sistema" "$ROOT_DIR/scripts/install-packages.sh"

plan_start_stage "🐚 Terminal tools"
plan_add_step "Configurar" "Shell zsh" "$ROOT_DIR/scripts/install-zsh.sh"
plan_add_step "Instalar" "lsd" "$ROOT_DIR/scripts/install-lsd.sh"
plan_add_step "Configurar" "Prompt Starship" "$ROOT_DIR/scripts/install-starship.sh"

plan_start_stage "👨‍💻 Developer tools"
plan_add_step "Provisionar" "Docker Engine y CLI" "$ROOT_DIR/scripts/install-docker.sh"
plan_add_step "Instalar" "VS Code" "$ROOT_DIR/scripts/install-vscode.sh"
plan_add_step "Instalar" "Postman" "$ROOT_DIR/scripts/install-postman.sh"

plan_start_stage "🌐 Browsers"
plan_add_step "Instalar" "Google Chrome" "$ROOT_DIR/scripts/install-chrome.sh"
plan_add_step "Instalar" "Brave" "$ROOT_DIR/scripts/install-brave-origin.sh"

plan_start_stage "🧩 Desktop"
plan_add_step "Instalar" "Flameshot" "$ROOT_DIR/scripts/install-flameshot.sh"

plan_start_stage "✨ Final Touches"
plan_add_step "Preparar" "Directorios de configuracion" "$ROOT_DIR/scripts/create-directories.sh"
plan_add_step "Enlazar" "Dotfiles y configuracion de agentes" "$ROOT_DIR/scripts/link-dotfiles.sh"
plan_add_step "Inicializar" "Plantillas locales" "$ROOT_DIR/scripts/init-templates.sh"

DOTFILES_TOTAL_STEPS="$(plan_steps_count)"
DOTFILES_CURRENT_STEP=0

if (( DOTFILES_TOTAL_STEPS == 0 )); then
	printf "%b%s%b\n" "$DOTFILES_COLOR_WARNING" "⚠️  No hay steps para ejecutar." "$DOTFILES_COLOR_RESET"
	exit 0
fi

plan_run
