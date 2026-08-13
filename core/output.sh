#!/usr/bin/env bash

print_bootstrap_banner() {
    printf "%b\n" "$DOTFILES_COLOR_TITLE"
    cat <<'EOF'
       __      __  _____ __
  ____/ /___  / /_/ __(_) /__  _____
 / __  / __ \/ __/ /_/ / / _ \/ ___/
/ /_/ / /_/ / /_/ __/ / /  __(__  )
\__,_/\____/\__/_/ /_/_/\___/____/
EOF
    printf "%b\n" "$DOTFILES_COLOR_RESET"
}

print_stage_title() {
    local title="$1"

    printf "\n%b%s%b\n" "$DOTFILES_COLOR_INFO" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$DOTFILES_COLOR_RESET"
    printf "%b  %s%b\n" "$DOTFILES_COLOR_TITLE" "$title" "$DOTFILES_COLOR_RESET"
    printf "%b%s%b\n" "$DOTFILES_COLOR_INFO" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$DOTFILES_COLOR_RESET"
}

print_platform_summary() {
    printf "%b%s%b\n" "$DOTFILES_COLOR_INFO" "🖥️  Plataforma detectada" "$DOTFILES_COLOR_RESET"
    printf "%b  %-10s%b %s\n" "$DOTFILES_COLOR_STEP" "OS:" "$DOTFILES_COLOR_RESET" "${DOTFILES_OS:-unknown}"
    printf "%b  %-10s%b %s\n" "$DOTFILES_COLOR_STEP" "Distro:" "$DOTFILES_COLOR_RESET" "${DOTFILES_DISTRO:-unknown}"
    printf "%b  %-10s%b %s\n" "$DOTFILES_COLOR_STEP" "Version:" "$DOTFILES_COLOR_RESET" "${DOTFILES_VERSION:-unknown}"
    printf "%b  %-10s%b %s\n" "$DOTFILES_COLOR_STEP" "ID:" "$DOTFILES_COLOR_RESET" "${DOTFILES_VERSION_ID:-unknown}"
    printf "%b  %-10s%b %s\n" "$DOTFILES_COLOR_STEP" "Codename:" "$DOTFILES_COLOR_RESET" "${DOTFILES_CODENAME:-unknown}"
    printf "%b  %-10s%b %s\n" "$DOTFILES_COLOR_STEP" "Arch:" "$DOTFILES_COLOR_RESET" "${DOTFILES_ARCH:-unknown}"
    printf "\n"
}

format_title() {
    local prefix="$1"
    local text="$2"

    printf "%s%s%s %s%s%s" \
        "$DOTFILES_COLOR_STEP" \
        "$prefix" \
        "$DOTFILES_COLOR_RESET" \
        "$DOTFILES_COLOR_TITLE" \
        "$text" \
        "$DOTFILES_COLOR_RESET"
}

format_preview() {
    local line="$1"

    printf "%s    %s%s" \
        "$DOTFILES_COLOR_PREVIEW" \
        "$line" \
        "$DOTFILES_COLOR_RESET"
}

format_duration() {
    local seconds="$1"

    if (( seconds < 60 )); then
        echo "${seconds}s"
    else
        echo "$((seconds / 60))m$((seconds % 60))s"
    fi
}

with_pending() {
    printf "%s %s" "$1" "$DOTFILES_SYM_PENDING"
}

with_check() {
    printf "%s %s%s%s" "$1" "$DOTFILES_COLOR_SUCCESS" "$DOTFILES_SYM_SUCCESS" "$DOTFILES_COLOR_RESET"
}

with_cross() {
    printf "%s %s%s%s" "$1" "$DOTFILES_COLOR_ERROR" "$DOTFILES_SYM_ERROR" "$DOTFILES_COLOR_RESET"
}

with_duration() {
    duration=$(format_duration "$2")
    printf "%s (%s)" "$1" "$duration"
}
