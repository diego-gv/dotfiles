#!/usr/bin/env zsh
# vim: set filetype=zsh

# Helper function to read ~/.gitusers, show list, and let user pick or create a new profile
# Outputs selected name and email via global variables: SELECTED_NAME, SELECTED_EMAIL
function _git_select_or_create_user() {
  local gitusers_file="$HOME/.gitusers"
  local current_name="$1"
  local current_email="$2"
  local -a names emails
  local choice name email

  [[ ! -f $gitusers_file ]] && touch $gitusers_file

  # Read users (skip invalid lines)
  while IFS=: read -r u_name u_email; do
    [[ -n "$u_name" && -n "$u_email" ]] || continue
    names+=("$u_name")
    emails+=("$u_email")
  done < "$gitusers_file"

  echo "\nSelect a user profile:"
  local i=1
  local default=''
  if (( ${#names} > 0 )); then
    for entry_name in "${(@k)names}"; do
      local entry_email="${emails[i]}"
      if [[ "$entry_name" == "$current_name" && "$entry_email" == "$current_email" ]]; then
        echo "  $i - $entry_name <$entry_email> (current)"
        default=$i
      else
        echo "  $i - $entry_name <$entry_email>"
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

      # Append new user only if not exists
      if ! grep -qx "$name:$email" "$gitusers_file"; then
        echo "$name:$email" >> "$gitusers_file"
        echo "New user entry created."
      else
        echo "User already exists. Using existing entry."
      fi

      SELECTED_NAME=$name
      SELECTED_EMAIL=$email
      break
    done
  elif (( choice >= 1 && choice < i )); then
    local index=$((choice))
    SELECTED_NAME="${names[index]}"
    SELECTED_EMAIL="${emails[index]}"
  else
    echo "❌ Invalid choice. Aborting."
    return 1
  fi

}

function _git_clone() {

  local url target_dir

  # Find the first non-option argument as the URL
  for (( i = 2; i <= $#argv; i++ )); do
    if [[ ! ${argv[i]} == -* ]]; then
      url="${argv[i]}"
      # If there is another non-option argument after the URL, use it as target_dir
      if (( i < $#argv )) && [[ ! ${argv[i+1]} == -* ]]; then
        target_dir="${argv[i+1]}"
      else
        target_dir=$(basename "$url" .git)
      fi
      break
    fi
  done

  # Run clone, abort if fails
  if ! command git clone "${(@)argv[2,-1]}"; then
    echo "❌ git clone failed. Aborting."
    return 1
  fi

  # Select or create user profile
  _git_select_or_create_user || {
    [[ -d "$target_dir" ]] && rm -rf "$target_dir"
    return 1
  }

  # Configure user in cloned repo
  if [[ -d "$target_dir" ]]; then
    git -C "$target_dir" config user.name "$SELECTED_NAME"
    git -C "$target_dir" config user.email "$SELECTED_EMAIL"
    echo "\n✅ Configured git user: $SELECTED_NAME <$SELECTED_EMAIL> in $target_dir"
  else
    echo "\n⚠️ Cloned directory '$target_dir' not found."
  fi
  return 0

}

function _git_user() {

  # Check if inside a git repo
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "❌ Not a git repository."
    return 1
  fi

  # Read current configured user
  local current_name=$(git config user.name)
  local current_email=$(git config user.email)

  # Use helper to select/create user
  _git_select_or_create_user "$current_name" "$current_email" || return 1

  # Show current user if matches selected
  if [[ "$SELECTED_NAME" == "$current_name" && "$SELECTED_EMAIL" == "$current_email" ]]; then
    echo "\nℹ️  Selected user is already configured as current user."
  fi

  # Configure local repo user
  git config user.name "$SELECTED_NAME"
  git config user.email "$SELECTED_EMAIL"
  echo "\n✅ Configured git user: $SELECTED_NAME <$SELECTED_EMAIL> for current repository"
  return 0

}

function _git_user_list() {
  local gitusers_file="$HOME/.gitusers"
  local -a names emails

  [[ ! -f $gitusers_file ]] && {
    echo "No user profiles found."
    return 0
  }

  # Leer usuarios válidos
  while IFS=: read -r u_name u_email; do
    [[ -n "$u_name" && -n "$u_email" ]] || continue
    names+=("$u_name")
    emails+=("$u_email")
  done < "$gitusers_file"

  if (( ${#names} == 0 )); then
    echo "No user profiles found."
    return 0
  fi

  # Obtener usuario actual si es un repositorio git
  local current_name="" current_email=""
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    current_name=$(git config user.name)
    current_email=$(git config user.email)
  fi

  echo "\n📋 Available Git user profiles:"
  for i in {1..${#names}}; do
    local name="${names[i]}"
    local email="${emails[i]}"
    if [[ "$name" == "$current_name" && "$email" == "$current_email" ]]; then
      echo "  $i - $name <$email> (current)"
    else
      echo "  $i - $name <$email>"
    fi
  done
}


git() {

  # Extend git clone
  if [[ "$1" == "clone" ]]; then

    _git_clone "$@"

  # New command git user
  elif [[ "$1" == "user" ]]; then
    if [[ "$2" == "--list" ]]; then
      _git_user_list
      return 0
    fi

    _git_user

  # Another git command
  else
    command git "$@"
  fi

}
