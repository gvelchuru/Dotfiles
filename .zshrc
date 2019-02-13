# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH export PATH=$HOME/neovim/bin:$PATH #TODO: CLEAN UP export PATH=$HOME/bin:/usr/local/bin:$PATH
export TERM="xterm-256color"
setopt NO_BEEP

if [[ -e /usr/share/zsh/scripts/zplug/init.zsh ]] ; then
    source /usr/share/zsh/scripts/zplug/init.zsh
else
    source ~/zplug/init.zsh
    zplug zplug/zplug, hook-build:'zplug --self-manage'
fi
  # specify plugins here
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme
zplug zdharma/fast-syntax-highlighting
zplug zsh-users/zsh-autosuggestions
zplug ael-code/zsh-colored-man-pages
zplug MichaelAquilina/zsh-you-should-use
zplug "bri3/nice-exit-code", from:oh-my-zsh
#zplug bri3/nice-exit-code
zplug "plugins/git",   from:oh-my-zsh
zplug "lib/history",   from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug desyncr/auto-ls
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "ardagnir/athame"

#if ! zplug check --verbose; then
    #printf "Install? [y/N]: "
    #if read -q; then
        #echo; zplug install
    #fi
#fi
#
#zplug check || zplug install

#zplug load --verbose
zplug load

#Async updates for speed
async_init
async_start_worker my_worker
async_job my_worker zplug check || zplug install > /dev/null
async_job my_worker zplug update > /dev/null

SPACESHIP_PROMPT_ORDER=(
  time          # Time stampts section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  #node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  xcode         # Xcode section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  dotnet        # .NET section
  ember         # Ember.js section
  kubecontext   # Kubectl context section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  #vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
  )

SPACESHIP_CHAR_SYMBOL=❯
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_CONDA_SYMBOL=🐍
SPACESHIP_EXIT_CODE_SHOW="true"
SPACESHIP_GIT_STATUS_PREFIX="·"
SPACESHIP_GIT_STATUS_SUFFIX=""
SPACESHIP_GIT_STATUS_COLOR="magenta"
#SPACESHIP_EXIT_CODE_SUFFIX=$(nice_exit_code)


export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)))"   # use all vcpus when compiling

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

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
 export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias lock="xset dpms force off && /home/gauthv/lock.sh"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme
#   {{{ FILE MANAGEMENT


#alias startup="yay -Syu --devel --sudoloop && sudo sh /home/gauthv/backup.sh && rclone -P sync /mnt/data1/gdrive/batcave_backup gdrive:batcave_backup && exit"
alias startup="yay -Syu --devel --sudoloop && gksu sh /home/gauthv/backup.sh && exit"

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
#

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

# {{{ OTHER ALIASES
alias ap='sudo create_ap --config ~/.config/create_ap.conf' # spawn wifi spot
alias bm='bmon -p wlp0s29u1u2,wlp0s29u1u1,wlp2s0,ap0 -o "curses:fgchar=S;bgchar=.;nchar=N;uchar=?;details"'
alias kal='khal interactive'                            # show calendar
alias ip='ip -c'                                        # colored ip

#alias gc='git commit -am'                               # git commit with message
#alias gl='git log --graph --oneline --decorate --all'   # graph git log
#alias gs='git status -sb'                               # simplify git status

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
bindkey "^R" history-incremental-pattern-search-backward
export PATH="/home/gauthv/.cargo/bin:$PATH"
export PATH="/usr/lib/ccache/bin/:$PATH"
# }}}
#

if [[ -d /opt/anaconda ]] ; then
. /opt/anaconda/etc/profile.d/conda.sh
else
. $HOME/miniconda3/etc/profile.d/conda.sh
fi
#conda activate

if [[ -e /etc/profile.d/autojump.zsh ]] ; then
    source /etc/profile.d/autojump.zsh
else
    source $HOME/.autojump/etc/profile.d/autojump.sh
fi
autoload -U compinit && compinit -u

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:$HOME/.rvm/bin"
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
