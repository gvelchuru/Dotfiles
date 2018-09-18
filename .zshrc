# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/.local/bin:$PATH
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/miniconda3/bin:$PATH
export TERM="xterm-256color"
setopt NO_BEEP

# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)))"   # use all vcpus when compiling
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir_writable dir vcs anaconda)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_LINUX_ICON='\uf17c'
# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
 CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh
source "$HOME/.rvm/scripts/rvm"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
 export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme
#   {{{ FILE MANAGEMENT
alias cp='cp -iv'               # interactive and verbose cp
alias l='ls -l -a'              # list all files
alias ll='ls -l'                # list files

alias ls="exa -bghHliS"

alias mkdir='mkdir -p'          # do not clobber files when making paths
alias mv='mv -iv'               # interactive and verbose mv
alias rm='rm -iv'               # interactive and verbose rm

# Kitty aliases
alias icat="kitty +kitten icat"

#function ls {
    #command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" | less -R -X -F
#}

function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
#   }}}

#   {{{ SHELL MANAGEMENT
alias path='echo -e ${PATH//:/\\n}'                 # show executable paths
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'   # show library paths
alias testpowerline='echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"'
#   }}}

#   {{{ WEB SERVICES
cheatsheet() { curl cheat.sh/$1; }                      # get command cheatsheet
qrcode() { echo $@ | curl -F-=\<- qrenco.de; }          # print qrcode
alias weather='curl -s wttr.in/~白井市 | head -7'       # print weather
alias weatherforecast='curl -s wttr.in/~白井市 | head -37 | tail -30'
#   }}}

alias ap='sudo create_ap --config ~/.config/create_ap.conf' # spawn wifi spot
alias bm='bmon -p wlp0s29u1u2,wlp0s29u1u1,wlp2s0,ap0 -o "curses:fgchar=S;bgchar=.;nchar=N;uchar=?;details"'
alias kal='khal interactive'                            # show calendar
alias ip='ip -c'                                        # colored ip

alias gc='git commit -am'                               # git commit with message
alias gl='git log --graph --oneline --decorate --all'   # graph git log
alias gs='git status -sb'                               # simplify git status

alias grep='grep --color=auto'                          # colored grep

alias less='less -i'                                    # case insensitive search
alias mutt='neomutt'                                    # neomutt
alias pactree='pactree --color'
alias qutebrowser='qutebrowser --backend webengine'     # webengine in qutebrowser

alias tree='tree -C'
alias vi='nvim'; alias vim='nvim'       # use nvim where vi or vim is called
alias vimdiff='nvim -d'                 # use nvim when diffing
# }}}

# {{{ ZSH OPTIONS
bindkey -v  # VIM mode
export PATH="/home/gauthv/.cargo/bin:$PATH"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
