#!/usr/bin/env bash

delete_preview_space() {
    local lines="$1"

    for ((i = 0; i < lines; i++)); do
        tput dl1
    done
}

redraw_preview() {
    local visible_lines="$1"
    shift

    local buffer=("$@")
    local start=0

    (( visible_lines == 0 )) && return 0

    tput cuu "$visible_lines"

    (( ${#buffer[@]} > visible_lines )) && start=$((${#buffer[@]} - visible_lines))

    for ((i = 0; i < visible_lines; i++)); do
        tput el

        local idx=$((start + i))

        if (( idx < ${#buffer[@]} )); then
            format_preview "${buffer[$idx]}"
        fi

        printf '\n'
    done
}

run_command_capture_output() {
    local cmd="$1"
    local rc_file="$2"
    local rc

    set +e
    bash -lc "$cmd" 2>&1
    rc=$?
    set -e

    echo "$rc" > "$rc_file"
}

run_with_preview() {
    local cmd="$1"
    local text="${2:-$cmd}"
    local max_lines="${3:-$DOTFILES_PREVIEW_LINES}"

    local buffer=()
    local rc
    local prefix
    local title
    local pending_title
    local final_title
    local rc_file
    local visible_lines=0
    local start_time
    local duration

    DOTFILES_CURRENT_STEP=$((DOTFILES_CURRENT_STEP + 1))
    prefix="[$DOTFILES_CURRENT_STEP/$DOTFILES_TOTAL_STEPS]"
    rc_file="$(mktemp)"
    start_time="$(date +%s)"

    title="$(format_title "$prefix" "$text")"
    pending_title="$(with_pending "$title")"

    printf "%s\n" "$pending_title"

    while IFS= read -r line; do
        buffer+=("$line")

        if (( visible_lines < max_lines )); then
            visible_lines=$((visible_lines + 1))
            printf '\n'
        fi

        redraw_preview "$visible_lines" "${buffer[@]}"
    done < <(run_command_capture_output "$cmd" "$rc_file")

    rc="$(cat "$rc_file")"
    rm -f "$rc_file"

    duration=$(($(date +%s) - start_time))

    tput cuu $((visible_lines + 1))
    tput el

    if (( rc == 0 )); then
        final_title="$(with_duration "$(with_check "$title")" "$duration")"
        printf "%s\n" "$final_title"
        delete_preview_space "$visible_lines"
    else
        final_title="$(with_duration "$(with_cross "$title")" "$duration")"
        printf "%s\n" "$final_title"

        tput cud "$visible_lines"

        printf "%sERROR:%s command failed: %s (exit code %s). Aborting execution.\n" \
            "$DOTFILES_COLOR_ERROR" \
            "$DOTFILES_COLOR_RESET" \
            "$cmd" \
            "$rc"

        exit "$rc"
    fi
}
