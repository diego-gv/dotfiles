#!/usr/bin/env zsh
# vim: set filetype=zsh

_gitusers_file_path() {
    local xdg_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    local git_config_dir="$xdg_config_home/git"

    mkdir -p "$git_config_dir"

    echo "$git_config_dir/users"
}

_git_load_users() {
    local gitusers_file
    gitusers_file="$(_gitusers_file_path)"

    typeset -g -a GIT_USER_NAMES
    typeset -g -a GIT_USER_EMAILS
    GIT_USER_NAMES=()
    GIT_USER_EMAILS=()

    [[ ! -f "$gitusers_file" ]] && touch "$gitusers_file"

    while IFS=: read -r u_name u_email; do
        [[ -n "$u_name" && -n "$u_email" ]] || continue
        GIT_USER_NAMES+=("$u_name")
        GIT_USER_EMAILS+=("$u_email")
    done < "$gitusers_file"
}

_git_ensure_user_exists() {
    local name="$1"
    local email="$2"
    local gitusers_file
    gitusers_file="$(_gitusers_file_path)"

    if ! grep -qx "$name:$email" "$gitusers_file"; then
        echo "$name:$email" >> "$gitusers_file"
        echo "New user entry created."
    fi
}

_git_apply_user_to_repo() {
    local name="$1"
    local email="$2"

    if ! command git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "Not a git repository."
        return 1
    fi

    command git config user.name "$name"
    command git config user.email "$email"
    echo "Configured git user: $name <$email> for current repository"
}

# Interactive profile selection/creation.
_git_user_interactive() {
    _git_load_users

    local current_name current_email
    local choice name email
    current_name="$(command git config user.name 2>/dev/null || true)"
    current_email="$(command git config user.email 2>/dev/null || true)"

    echo "\nSelect a user profile:"
    local i=1
    local default=""

    if (( ${#GIT_USER_NAMES} > 0 )); then
        for name in "${(@)GIT_USER_NAMES}"; do
            local email_at_index="${GIT_USER_EMAILS[i]}"
            if [[ "$name" == "$current_name" && "$email_at_index" == "$current_email" ]]; then
                echo "  $i - $name <$email_at_index> (current)"
                default="$i"
            else
                echo "  $i - $name <$email_at_index>"
            fi
            ((i++))
        done
    fi

    default="${default:-$i}"
    echo "  $i - Create new user"

    read "choice?Enter your choice [$default]: "
    choice="${choice:-$default}"

    if (( choice == i )); then
        while true; do
            read "name?  - Enter user name: "
            read "email?  - Enter user email: "
            [[ -z "$name" || -z "$email" ]] && echo "Both fields are required." && continue
            _git_ensure_user_exists "$name" "$email"
            _git_apply_user_to_repo "$name" "$email"
            return $?
        done
    fi

    if (( choice >= 1 && choice < i )); then
        _git_apply_user_to_repo "${GIT_USER_NAMES[choice]}" "${GIT_USER_EMAILS[choice]}"
        return $?
    fi

    echo "Invalid choice. Aborting."
    return 1
}

_git_user_list() {
    _git_load_users

    if (( ${#GIT_USER_NAMES} == 0 )); then
        echo "No user profiles found."
        return 0
    fi

    local current_name="" current_email=""
    if command git rev-parse --is-inside-work-tree &>/dev/null; then
        current_name="$(command git config user.name 2>/dev/null || true)"
        current_email="$(command git config user.email 2>/dev/null || true)"
    fi

    local i
    echo "\nAvailable Git user profiles:"
    for i in {1..${#GIT_USER_NAMES}}; do
        local name="${GIT_USER_NAMES[i]}"
        local email="${GIT_USER_EMAILS[i]}"
        if [[ "$name" == "$current_name" && "$email" == "$current_email" ]]; then
            echo "  $i - $name <$email> (current)"
        else
            echo "  $i - $name <$email>"
        fi
    done
}

_git_user_set() {
    local name="$1"
    local email="$2"

    if [[ -z "$name" || -z "$email" ]]; then
        echo "Usage: git user --set <name> <email>"
        return 1
    fi

    _git_ensure_user_exists "$name" "$email"
    _git_apply_user_to_repo "$name" "$email"
}

_git_user_help() {
    echo "Usage:"
    echo "  git user                 # interactive profile selector"
    echo "  git user --list          # list saved profiles"
    echo "  git user --set N E       # set profile non-interactively"
}

_git_user_command() {
    case "$1" in
        "" )
            _git_user_interactive
            ;;
        --list)
            _git_user_list
            ;;
        --set)
            shift
            _git_user_set "$1" "$2"
            ;;
        --help|-h)
            _git_user_help
            ;;
        *)
            echo "Unknown option for git user: $1"
            _git_user_help
            return 1
            ;;
    esac
}

git() {
    if [[ "$1" == "user" ]]; then
        shift
        _git_user_command "$@"
        return $?
    fi

    command git "$@"
}
