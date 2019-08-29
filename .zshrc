setopt NO_BEEP
if [[ -d /apollo/env ]] ; then
  export PATH=/apollo/env/SDETools/bin:$PATH
  export PATH=/apollo/env/ApolloCommandLine/bin:$PATH
  export PATH=/apollo/env/AmazonAwsCli/bin:$PATH
  export PATH=/apollo/env/envImprovement/bin:$PATH
  export BRAZIL_COLORS=1
  export MANPATH=$ENV_IMPROVEMENT_ROOT/man:$ENV_IMPROVEMENT_ROOT/share/man:${MANPATH:-}:/usr/kerberos/man
  export P4CONFIG=.p4config  # see wiki/?P4CONFIG
  export P4EDITOR=$EDITOR        # editor used for perforce forms (submit, etc)
  export SYSSCREENRC=$ENV_IMPROVEMENT_ROOT/var/screenrc
  export USE_CACHE_WRAPPER=true  #turn on caching for various amazon completions
  export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short # Use short workspace layout in Brazil
  alias bb='brazil-build'
else
  export PATH=$HOME/.local/bin:$PATH
  export PATH=$HOME/.mozbuild/arcanist/bin:$PATH
  export PATH=$HOME/.mozbuild/moz-phab:$PATH
  export PATH=$HOME/.cargo/bin:$PATH
  export PATH=/usr/lib/ccache/bin:$PATH
  export PATH=$HOME/.mozbuild/git-cinnabar:$PATH
  #alias dislock='killall xautolock'
  #alias relock=xautolock -detectsleep -time 5 -locker "/home/gauthv/lock.sh" -notify 30 -notifier "notify-send -u critical -t 10000 -- 'LOCKING screen in 30 seconds'" &
  alias lock="xset dpms force off && /home/gauthv/lock.sh"
  alias startup="killall insync && insync start && yay -Syu --devel --sudoloop"
  alias startup_backup="startup && backup"
  alias backup="sudo sh /home/gauthv/backup.sh && insync_restart"
  alias insync_restart="gksudo 'chown -R gauthv:users /mnt/data1/gdrive/batcave_backup' && killall insync && insync start && exit"
fi
if [[ -d /apollo/env ]] ; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  export PATH=/home/linuxbrew/.linuxbrew/opt/ccache/libexec:$PATH
fi
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/bin:$PATH

if command -v tmux &> /dev/null && [[ -d /apollo/env ]] && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
fi

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
zplug "plugins/git",   from:oh-my-zsh
zplug "lib/history",   from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"

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
  #hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  #node          # Node.js section
  #ruby          # Ruby section
  #elixir        # Elixir section
  #xcode         # Xcode section
  #swift         # Swift section
  #golang        # Go section
  #php           # PHP section
  rust          # Rust section
  #haskell       # Haskell Stack section
  #julia         # Julia section
  #docker        # Docker section
  #aws           # Amazon Web Services section
  #venv          # virtualenv section
  conda         # conda virtualenv section
  #pyenv         # Pyenv section
  #dotnet        # .NET section
  #ember         # Ember.js section
  #kubecontext   # Kubectl context section
  exec_time     # Execution time
  line_sep      # Line break
  #battery       # Battery level and status
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

export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)))"   # use all vcpus when compiling

# Uncomment the following line to use case-sensitive completion.
 CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
 DISABLE_UNTRACKED_FILES_DIRTY="true"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

export LANG=en_US.UTF-8

export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

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
#   }}}

# {{{ OTHER ALIASES
alias ap='sudo create_ap --config ~/.config/create_ap.conf' # spawn wifi spot
alias bm='bmon -p wlp0s29u1u2,wlp0s29u1u1,wlp2s0,ap0 -o "curses:fgchar=S;bgchar=.;nchar=N;uchar=?;details"'
alias ip='ip -c'                                        # colored ip

alias grep='grep --color=auto'                          # colored grep

alias less='less -i'                                    # case insensitive search
alias mutt='neomutt'                                    # neomutt
alias pactree='pactree --color'

alias tree='tree -C'
alias vi='nvim'; alias vim='nvim'       # use nvim where vi or vim is called
alias vimdiff='nvim -d'                 # use nvim when diffing
# }}}
alias myscrots='scrot -s ~/Pictures/Screenshots/%b%d::%H%M%S.png'
alias myscrot='scrot ~/Pictures/Screenshots/%b%d::%H%M%S.png'

# {{{ ZSH OPTIONS
bindkey -v  # VIM mode
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^T" push-line-or-edit
# }}}

if [[ -d $HOME/anaconda3 ]] ; then
. $HOME/anaconda3/etc/profile.d/conda.sh
else
. $HOME/miniconda3/etc/profile.d/conda.sh
fi

conda activate
[[ -z $TMUX ]] || conda deactivate; conda activate

if [[ -e /etc/profile.d/autojump.zsh ]] ; then
    source /etc/profile.d/autojump.zsh
elif [[ -e /home/linuxbrew/.linuxbrew/Cellar/autojump/22.5.3/share/autojump/autojump.zsh ]] ; then
    source /home/linuxbrew/.linuxbrew/Cellar/autojump/22.5.3/share/autojump/autojump.zsh
else
    source $HOME/.autojump/etc/profile.d/autojump.sh
fi

[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

autoload -U compinit && compinit -u
autoload bashcompinit && bashcompinit
if [[ -d /apollo/env ]] ; then
  source /apollo/env/AmazonAwsCli/bin/aws_zsh_completer.sh
else
  [[ -f $HOME/mozilla_unified ]] && source $HOME/mozilla_unified/python/mach/bash-completion.sh
fi
