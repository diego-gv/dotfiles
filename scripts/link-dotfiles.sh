#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
source "$ROOT_DIR/core/symlink.sh"

ensure_safe_symlink "$ROOT_DIR/src/zsh/zshrc" "$HOME/.zshrc"
ensure_safe_symlink "$ROOT_DIR/src/zsh/zshenv" "$HOME/.zshenv"
ensure_safe_symlink "$ROOT_DIR/src/zsh/zshopt" "$HOME/.zshopt"
ensure_safe_symlink "$ROOT_DIR/src/git/gitconfig" "$HOME/.gitconfig"
ensure_safe_symlink "$ROOT_DIR/src/starship/starship.toml" "$HOME/.config/starship/starship.toml"
ensure_safe_symlink "$ROOT_DIR/src/fzf/fzf-preview.sh" "$HOME/.config/fzf/fzf-preview.sh"
ensure_safe_symlink "$ROOT_DIR/src/bat/config" "$HOME/.config/bat/config"
ensure_safe_symlink "$ROOT_DIR/src/btop/btop.conf" "$HOME/.config/btop/btop.conf"
ensure_safe_symlink "$ROOT_DIR/src/zsh/aliases.zsh" "$HOME/.config/oh-my-zsh/custom/aliases.zsh"
ensure_safe_symlink "$ROOT_DIR/src/zsh/styles.zsh" "$HOME/.config/oh-my-zsh/custom/styles.zsh"

for zsh_function_file in "$ROOT_DIR"/src/zsh/functions/*.zsh; do
    ensure_safe_symlink "$zsh_function_file" "$HOME/.config/oh-my-zsh/custom/functions/$(basename "$zsh_function_file")"
done


# Claude
ensure_safe_symlink "$ROOT_DIR/src/agents/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ensure_safe_symlink "$ROOT_DIR/src/agents/claude/settings.json" "$HOME/.claude/settings.json"

# Codex
ensure_safe_symlink "$ROOT_DIR/src/agents/codex/config.toml" "$HOME/.codex/config.toml"
ensure_safe_symlink "$ROOT_DIR/src/agents/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"

# Copilot
ensure_safe_symlink "$ROOT_DIR/src/agents/copilot/settings.json" "$HOME/.copilot/settings.json"
ensure_safe_symlink "$ROOT_DIR/src/agents/copilot/copilot-instructions.md" "$HOME/.copilot/copilot-instructions.md"

# Shared
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/agent-guidelines.md" "$HOME/.claude/agent-guidelines.md"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/agent-guidelines.md" "$HOME/.codex/agent-guidelines.md"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/agent-guidelines.md" "$HOME/.copilot/agent-guidelines.md"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/agent-guidelines.md" "$HOME/.agents/AGENTS.md"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/skills" "$HOME/.claude/skills"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/skills" "$HOME/.agents/skills"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/agents" "$HOME/.claude/agents"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/agents" "$HOME/.codex/agents"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/agents" "$HOME/.copilot/agents"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/rules" "$HOME/.claude/rules"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/rules" "$HOME/.codex/rules"
ensure_safe_symlink "$ROOT_DIR/src/agents/shared/prompts" "$HOME/.copilot/prompts"
