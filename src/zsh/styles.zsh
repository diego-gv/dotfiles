# F-Sy-H plugin
#############################
# Don't have configurations

# colored-man-pages plugin
#############################
# Don't have configurations

# sudo plugin
#############################
# Don't have configurations

# fzf-tab plugin
#############################
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# Set Custom fzf Preview for ls/lsd Completions - using fzf-preview
zstyle ':fzf-tab:complete:lsd:*' fzf-preview 'bash ${XDG_CONFIG_HOME}/fzf/fzf-preview.sh $realpath'
# preview directory's content with lsd when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always -A --icon=always --group-dirs first $realpath | head -200'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --bind=tab:down
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# # switch group using `,` and `.`
# zstyle ':fzf-tab:*' switch-group ',' '.'
# # remove prefix
# zstyle ':fzf-tab:*' prefix ''
# # Whether to automatically insert a space after the result.
# zstyle ':fzf-tab:*' insert-space false

# zsh-autosuggestions plugin
#############################
# Don't have configurations

# Other configurations
#############################
# Only display targets tag for make command completion
zstyle ':completion:*:*:make::' tag-order 'targets variables'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
