source $HOME/zsh_scripts/startup.sh

typeset -ga precmd_functions
typeset -ga preexec_functions

source $HOME/zsh_scripts/aliases.sh

# {{{ ZSH OPTIONS
bindkey -v  # VIM mode
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^T" push-line-or-edit
setopt PROMPT_SUBST
setopt HIST_IGNORE_ALL_DUPS
setopt hist_ignore_dups
autoload -U colors && colors
# }}}

source $HOME/zsh_scripts/conda.sh
source $HOME/zsh_scripts/source_autojump.sh

[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

source $HOME/zsh_scripts/zsh_completion.sh
source $HOME/zsh_scripts/antibody.sh

if [[ $APOLLO_EXISTS -eq 0 ]]; then
  source $HOME/zsh_scripts/apollo.sh
fi

#PROMPT='
#%~ %{$fg[red]%}$(nice_exit_code) %{$fg[green]%} %t
#%{$reset_color%}❯ '

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

export PATH=$HOME/.toolbox/bin:$PATH
export SPACESHIP_CHAR_SYMBOL=❯
export SPACESHIP_TIME_SHOW=false
export SPACESHIP_HOST_SHOW=always
export SPACESHIP_EXIT_CODE_SHOW=true
export SPACESHIP_VI_MODE_COLOR=green
