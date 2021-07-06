source $HOME/zsh_scripts/startup.sh

typeset -ga precmd_functions
typeset -ga preexec_functions

source $HOME/zsh_scripts/aliases.sh

# {{{ ZSH OPTIONS
bindkey -v  # VIM mode
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^T" push-line-or-edit
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt hist_ignore_dups
autoload -U colors && colors
# }}}

source $HOME/zsh_scripts/conda.sh
source $HOME/zsh_scripts/source_autojump.sh

[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

source $HOME/zsh_scripts/zsh_completion.sh
source $HOME/zsh_scripts/antigen.sh

#PROMPT='
#%~ %{$fg[red]%}$(nice_exit_code) %{$fg[green]%}
#%{$reset_color%}❯ '

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

export PATH=$HOME/.toolbox/bin:$PATH

eval "$(starship init zsh)"
export LD_LIBRARY_PATH=/opt/glibc-2.17/lib:$LD_LIBRARY_PATH

export PATH=$HOME/.toolbox/bin:$PATH
