#!/usr/bin/env bash

DOTFILES_PLAN_STAGE_TITLES=()
DOTFILES_PLAN_STAGE_STEP_COUNTS=()
DOTFILES_PLAN_STEP_ACTIONS=()
DOTFILES_PLAN_STEP_LABELS=()
DOTFILES_PLAN_STEP_SCRIPTS=()

plan_reset() {
    DOTFILES_PLAN_STAGE_TITLES=()
    DOTFILES_PLAN_STAGE_STEP_COUNTS=()
    DOTFILES_PLAN_STEP_ACTIONS=()
    DOTFILES_PLAN_STEP_LABELS=()
    DOTFILES_PLAN_STEP_SCRIPTS=()
}

plan_start_stage() {
    local title="$1"
    DOTFILES_PLAN_STAGE_TITLES+=("$title")
    DOTFILES_PLAN_STAGE_STEP_COUNTS+=(0)
}

plan_add_step() {
    local action="$1"
    local label="$2"
    local script_path="$3"
    local stage_idx

    stage_idx=$((${#DOTFILES_PLAN_STAGE_STEP_COUNTS[@]} - 1))
    if (( stage_idx < 0 )); then
        printf "%b%s%b\n" "$DOTFILES_COLOR_ERROR" "❌ No hay una etapa activa para el step: $label" "$DOTFILES_COLOR_RESET"
        exit 2
    fi

    DOTFILES_PLAN_STEP_ACTIONS+=("$action")
    DOTFILES_PLAN_STEP_LABELS+=("$label")
    DOTFILES_PLAN_STEP_SCRIPTS+=("$script_path")
    (( DOTFILES_PLAN_STAGE_STEP_COUNTS[stage_idx] += 1 ))
}

plan_steps_count() {
    echo "${#DOTFILES_PLAN_STEP_SCRIPTS[@]}"
}

plan_run() {
    local cursor=0
    local stage_idx
    local step_idx
    local title
    local count
    local step_action
    local step_label
    local step_script

    for stage_idx in "${!DOTFILES_PLAN_STAGE_TITLES[@]}"; do
        title="${DOTFILES_PLAN_STAGE_TITLES[$stage_idx]}"
        count="${DOTFILES_PLAN_STAGE_STEP_COUNTS[$stage_idx]}"

        print_stage_title "$title"

        for ((step_idx = 0; step_idx < count; step_idx++)); do
            step_action="${DOTFILES_PLAN_STEP_ACTIONS[$cursor]}"
            step_label="${DOTFILES_PLAN_STEP_LABELS[$cursor]}"
            step_script="${DOTFILES_PLAN_STEP_SCRIPTS[$cursor]}"

            run_with_preview "bash \"$step_script\"" "$step_action: $step_label"
            cursor=$((cursor + 1))
        done
    done
}
