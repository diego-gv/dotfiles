#!/usr/bin/env zsh
# vim: set filetype=zsh

# Wrapper for the `git` command that modifies the URL used in `git clone` based on specific patterns:
#
# - Converts HTTPS GitHub URLs to their SSH equivalents to improve authentication and SSH key usage.
# - For repositories under the `mapfre-tech` and `mapfre-lab` organizations:
#     - Uses a custom SSH alias `github.com-mapfre` to differentiate SSH keys or configurations.
# - For other GitHub repositories, converts HTTPS URLs to standard SSH URLs.
# - Preserves the presence or absence of the `.git` suffix to avoid duplication.
# - Supports both Bash and Zsh shells without relying on regex capture groups.
# - For commands other than `clone`, calls the original `git` command unchanged.
#
# Usage examples:
#   git clone https://github.com/mapfre-tech/project.git
#       => git clone git@github.com-mapfre:mapfre-tech/project.git
#
#   git clone https://github.com/user/other-repo
#       => git clone git@github.com:user/other-repo.git
#
# Requires appropriate configuration in ~/.ssh/config for the host alias `github.com-mapfre`.
#
# This function enables seamless use of different SSH keys or SSH configurations
# without changing the normal `git clone` command.
git() {
    if [[ "$1" == "clone" ]]; then
        local url="$2"
        local repo_path
        local has_dot_git=0

        # Detect if the URL ends with .git
        if [[ "$url" == *.git ]]; then
            has_dot_git=1
        fi

        if [[ "$url" =~ ^https://github\.com/ ]]; then
            # Extract the "org/repo" part using parameter expansion
            repo_path="${url#https://github.com/}"
            # Remove possible .git at the end to avoid duplicates
            repo_path="${repo_path%.git}"

            # Check if it is mapfre-tech or mapfre-lab to use the ssh alias
            if [[ "$repo_path" == mapfre-tech/* || "$repo_path" == mapfre-lab/* ]]; then
                url="git@github.com-mapfre:${repo_path}"
            else
                url="git@github.com:${repo_path}"
            fi

            # Add .git only if the original URL had it
            if (( has_dot_git )); then
                url="${url}.git"
            fi
        elif [[ "$url" =~ ^git@github\.com:(mapfre-tech|mapfre-lab)/ ]]; then
            url="${url/git@github.com:/git@github.com-mapfre:}"
        fi

        shift 2
        command git clone "$url" "$@"
        return
    fi

    command git "$@"
}
