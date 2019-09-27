source zsh_scripts/startup.sh
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ ! "$(uname)" =~ "Darwin" ]]; then
  if [[ -d /apollo/env ]] ; then
    exec tmux new-session -A -s main -c /workplace/$(whoami)
  else 
    exec tmux new-session -A -s main 
  fi
fi

typeset -ga precmd_functions
typeset -ga preexec_functions

source zsh_scripts/aliases.sh

# {{{ ZSH OPTIONS
bindkey -v  # VIM mode
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^T" push-line-or-edit
# }}}

. $HOME/miniconda3/etc/profile.d/conda.sh
[[ -z $TMUX ]] && conda activate || conda deactivate; conda activate

source zsh_scripts/source_autojump.sh
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

source zsh_scripts/zsh_completion.sh

antibody_source() {
  antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
}

[[ -f ~/.zsh_plugins.sh ]] || antibody_source
source ~/.zsh_plugins.sh

if [[ -d /apollo/env ]]; then
  source zsh_scripts/apollo.sh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(starship init zsh)"
