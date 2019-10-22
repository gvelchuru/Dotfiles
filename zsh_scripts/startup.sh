setopt NO_BEEP

export UNAME=$(uname)
[[ $UNAME =~ "Linux" ]];export IS_LINUX=$?
[[ $UNAME =~ "Darwin" ]];export IS_MAC=$?
[[ -d /apollo/env ]];export APOLLO_EXISTS=$?
[[ -d /home/linuxbrew ]];export HAS_BREW=$?

if [[ $APOLLO_EXISTS -eq 0 ]] ; then
    export HOSTNAME="apollo"
elif [[ $IS_MAC -eq 0 ]]; then
    export HOSTNAME="mac"
else
    export HOSTNAME=$(hostname)
fi
export BREW_PACKAGES=$HOME/.brew_$HOSTNAME\_packages
export BREW_CASKS=$HOME/.brew_$HOSTNAME\_casks

if [[ $IS_LINUX -eq 0 ]]; then 
  export NUM_CORES=$(nproc) 
elif [[ $IS_MAC -eq 0 ]] ; then
  export NUM_CORES=$(sysctl -n hw.ncpu)
fi

alias vimstartup="nvim --headless +PlugInstall +PlugUpdate +PlugUpgrade +qa"
alias pythonstartup="yes | conda update --all && yes | conda update -n base -c defaults conda && conda env export > environment_$HOSTNAME.yaml"
alias nodestartup="npm-check -gy  && npm list --global --parseable --depth=1 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > ~/.node_$HOSTNAME\_packages"
alias commonstartup="vimstartup && antibody_source && antibody update && nodestartup; pythonstartup"
alias brewstartup="brew update; brew upgrade; brew cask upgrade; brew list > $BREW_PACKAGES; brew cask ls > $BREW_CASKS"
alias fzf="fzf --bind '~:execute(nvim {})'"
alias apollo_auth_init="mwinit -o && kinit -f"

if [[ $APOLLO_EXISTS -eq 0 ]]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  export PATH=/home/linuxbrew/.linuxbrew/sbin:$PATH
  export PATH=/home/linuxbrew/.linuxbrew/opt/ccache/libexec:$PATH
  if [[ $HAS_BREW -gt 0 ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    grep -Ev 'lib|xdpyinfo|antibody|xorg|xtrans' $BREW_PACKAGES | xargs brew install
    brew install getantibody/tap/antibody
  fi
  for d in /apollo/env/*; do
    export PATH=$d/bin:$PATH
  done
  export BRAZIL_COLORS=1
  export MANPATH=$ENV_IMPROVEMENT_ROOT/man:$ENV_IMPROVEMENT_ROOT/share/man:${MANPATH:-}:/usr/kerberos/man:$MANPATH
  export P4CONFIG=.p4config  # see wiki/?P4CONFIG
  export P4EDITOR=$EDITOR        # editor used for perforce forms (submit, etc)
  export SYSSCREENRC=$ENV_IMPROVEMENT_ROOT/var/screenrc
  export USE_CACHE_WRAPPER=true  #turn on caching for various amazon completions
  export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short # Use short workspace layout in Brazil
  export BRAZIL_PLATFORM_OVERRIDE=AL2012
  alias bb='bear -a brazil-build'
  alias bre='brazil-runtime-exec'
  alias startup="cd ~ && gl && apollo_auth_init && yes | sudo yum update && yes | sudo yum upgrade && brewstartup && commonstartup"
elif [[ $IS_MAC -eq 0 ]] ; then
  alias startup="cd ~ && gl && apollo_auth_init && brewstartup && commonstartup"
  alias sshdev='ssh -XC dev-dsk-velchug-2a-92c3caa5.us-west-2.amazon.com'
  alias moshdev='mosh --server=/home/linuxbrew/.linuxbrew/bin/mosh-server dev-dsk-velchug-2a-92c3caa5.us-west-2.amazon.com'
else
  export PATH=$HOME/.local/bin:$PATH
  export PATH=$HOME/.mozbuild/arcanist/bin:$PATH
  export PATH=$HOME/.mozbuild/moz-phab:$PATH
  export PATH=/usr/lib/ccache/bin:$PATH
  export PATH=$HOME/.mozbuild/git-cinnabar:$PATH
  alias dislock='killall xautolock'
  alias relock='xautolock -detectsleep -time 5 -locker "/home/gauthv/lock.sh" -notify 30 -notifier "notify-send -u critical -t 10000 -- 'LOCKING screen in 30 seconds'" &'
  alias lock="xset dpms force off && /home/gauthv/lock.sh"
  alias startup="cd ~ && gl && killall insync && insync start && yay -Syu --devel --sudoloop && commonstartup"
  alias startup_backup="startup && backup"
  alias backup="sudo sh /home/gauthv/backup.sh && insync_restart"
  alias insync_restart="gksudo 'chown -R gauthv:users /mnt/data1/gdrive/batcave_backup' && killall insync && insync start && exit"
fi
export PATH=$HOME/.cargo/bin:$PATH
