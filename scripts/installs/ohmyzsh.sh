#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r ZSH="${HOME}/.oh-my-zsh"
declare -r ZSH_PLUGINS_DIR="${ZSH}/custom"

declare -rA ZSH_PLUGINS=(
    # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
    ["plugins/F-Sy-H"]="https://github.com/z-shell/F-Sy-H"
    ["plugins/fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
    ["plugins/zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
	# ["plugins/zsh-bat"]="https://github.com/fdellwing/zsh-bat"  # Pending to test
    # Remove useless or broken
    # ["plugins/you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use"
    # ["plugins/zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    # ["plugins/zsh-direnv"]="https://github.com/ptavares/zsh-direnv"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


install() {

    if ! dir_exists "$ZSH" ; then
        ask_for_sudo
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &> /dev/null
    fi

}


update() {
    zsh -c 'source ${HOME}/.zshrc && omz update && exit'
}


install_plugins() {

	for name in "${!ZSH_PLUGINS[@]}"; do
		repo=${ZSH_PLUGINS[$name]}
		if ! dir_exists "${ZSH_PLUGINS_DIR}/$name" ; then
			{
				git clone --quiet "$repo" "${ZSH_PLUGINS_DIR}/$name" || return 1
			}
		fi
	done

}

update_plugins() {

    for name in "${!ZSH_PLUGINS[@]}"; do
		repo=${ZSH_PLUGINS[$name]}
		if [[ -d "${ZSH_PLUGINS_DIR}/$name" ]]; then
			{
				git -C "${ZSH_PLUGINS_DIR}/$name" pull --quiet || return 1
			}
		fi
	done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    execute "install" "OhMyZsh (install)"
    execute "update" "OhMyZsh (update)"

    execute "install_plugins" "OhMyZsh Plugins (install)"
    execute "update_plugins" "OhMyZsh Plugins (update)"

}

main
