#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO_URL="${DOTFILES_REPO_URL:-git@github.com:diego-gv/dotfiles.git}"
DOTFILES_ARCHIVE_URL="${DOTFILES_ARCHIVE_URL:-https://github.com/diego-gv/dotfiles/archive/refs/heads/feature/a-new-hope.tar.gz}"
DOTFILES_TARGET_DIR="${DOTFILES_TARGET_DIR:-$HOME/.dotfiles}"
DOTFILES_STAGE_DIR="${DOTFILES_STAGE_DIR:-}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$ROOT_DIR/core/config.sh" ]]; then
	if [[ -f "$ROOT_DIR/scripts/bootstrap-remote.sh" ]]; then
		exec bash "$ROOT_DIR/scripts/bootstrap-remote.sh"
	fi

	# Fallback one-liner: solo existe bootstrap.sh, sin arbol de scripts/core.
	tmp_base_dir="${TMPDIR:-$HOME/.tmp}"
	mkdir -p "$tmp_base_dir" 2>/dev/null || tmp_base_dir="$HOME"
	DOTFILES_STAGE_DIR="$(mktemp -d "${tmp_base_dir}/dotfiles.XXXXXX" 2>/dev/null || mktemp -d "${HOME}/dotfiles.XXXXXX")"
	archive_path="$DOTFILES_STAGE_DIR/dotfiles.tar.gz"
	stage_repo_dir="$DOTFILES_STAGE_DIR/repo"

	if [[ "$DOTFILES_ARCHIVE_URL" == file://* ]]; then
		cp "${DOTFILES_ARCHIVE_URL#file://}" "$archive_path"
	elif command -v curl >/dev/null 2>&1; then
		curl -fsSL "$DOTFILES_ARCHIVE_URL" -o "$archive_path"
	elif command -v wget >/dev/null 2>&1; then
		wget -qO "$archive_path" "$DOTFILES_ARCHIVE_URL"
	else
		printf "ERROR: No se pudo descargar el repositorio desde %s\n" "$DOTFILES_ARCHIVE_URL" >&2
		exit 1
	fi

	mkdir -p "$stage_repo_dir"
	tar --extract --gzip --file "$archive_path" --strip-components 1 --directory "$stage_repo_dir"

	exec env \
		DOTFILES_STAGE_DIR="$DOTFILES_STAGE_DIR" \
		DOTFILES_TARGET_DIR="$DOTFILES_TARGET_DIR" \
		DOTFILES_REPO_URL="$DOTFILES_REPO_URL" \
		DOTFILES_ARCHIVE_URL="$DOTFILES_ARCHIVE_URL" \
		bash "$stage_repo_dir/bootstrap.sh"
fi

if [[ -n "$DOTFILES_STAGE_DIR" ]]; then
	trap 'rm -rf "$DOTFILES_STAGE_DIR"' EXIT
fi

source "$ROOT_DIR/core/config.sh"
source "$ROOT_DIR/core/output.sh"
source "$ROOT_DIR/core/platform.sh"
source "$ROOT_DIR/core/plan.sh"
source "$ROOT_DIR/core/runner.sh"

prepare_target_repository() {
	[[ -n "$DOTFILES_STAGE_DIR" ]] || return 0

	print_stage_title "📥 Install / Download"

	if [[ -e "$DOTFILES_TARGET_DIR" ]]; then
		print_step_status "0/X" "Preparando repositorio local" "✗" "El directorio destino ya existe: $DOTFILES_TARGET_DIR"
		exit 1
	fi

	if ! mkdir -p "$(dirname "$DOTFILES_TARGET_DIR")" || ! mkdir -p "$DOTFILES_TARGET_DIR"; then
		print_step_status "0/X" "Preparando repositorio local" "✗" "No se pudo crear el directorio destino"
		exit 1
	fi

	if ! tar -C "$ROOT_DIR" -cf - . | tar -C "$DOTFILES_TARGET_DIR" -xf -; then
		print_step_status "0/X" "Preparando repositorio local" "✗" "No se pudo copiar el repositorio al destino final"
		exit 1
	fi

	ROOT_DIR="$DOTFILES_TARGET_DIR"
	print_step_status "0/X" "Preparando repositorio local" "✓" "$DOTFILES_TARGET_DIR"
}

export DOTFILES_REPO_URL DOTFILES_TARGET_DIR

detect_platform

print_bootstrap_banner
print_platform_summary

require_ubuntu

prepare_target_repository

plan_reset

plan_start_stage "🛠️  Bootstrap / System"
plan_add_step "Provisionar" "Paquetes base del sistema" "$ROOT_DIR/scripts/install-packages.sh"
plan_add_step "Preparar" "Directorios de configuracion" "$ROOT_DIR/scripts/create-directories.sh"
plan_add_step "Instalar" "Fuentes y tipografías" "$ROOT_DIR/scripts/install-fonts.sh"

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

plan_start_stage "🗂️  Configuration Files"
plan_add_step "Enlazar" "Dotfiles y configuracion de agentes" "$ROOT_DIR/scripts/link-dotfiles.sh"
plan_add_step "Inicializar" "Plantillas locales" "$ROOT_DIR/scripts/init-templates.sh"
plan_add_step "Configurar" "Repositorio git local" "$ROOT_DIR/scripts/configure-git-origin.sh"

DOTFILES_TOTAL_STEPS="$(plan_steps_count)"
DOTFILES_CURRENT_STEP=0

if (( DOTFILES_TOTAL_STEPS == 0 )); then
	printf "%b%s%b\n" "$DOTFILES_COLOR_WARNING" "⚠️  No hay steps para ejecutar." "$DOTFILES_COLOR_RESET"
	exit 0
fi

plan_run
