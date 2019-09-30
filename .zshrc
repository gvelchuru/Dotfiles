source $HOME/zsh_scripts/startup.sh
source $HOME/zsh_scripts/tmux_setup.sh

typeset -ga precmd_functions
typeset -ga preexec_functions

source $HOME/zsh_scripts/aliases.sh

# {{{ ZSH OPTIONS
bindkey -v  # VIM mode
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^T" push-line-or-edit
# }}}

source $HOME/zsh_scripts/conda.sh
source $HOME/zsh_scripts/source_autojump.sh

[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

source $HOME/zsh_scripts/zsh_completion.sh
source $HOME/zsh_scripts/antibody.sh

if [[ $APOLLO_EXISTS -eq 0 ]]; then
  source $HOME/zsh_scripts/apollo.sh
fi

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
eval "$(starship init zsh)"
