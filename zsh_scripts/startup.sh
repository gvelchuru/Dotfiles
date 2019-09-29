setopt NO_BEEP
alias vimstartup="nvim --headless +PlugInstall +PlugUpdate +PlugUpgrade +qa"
alias pythonstartup="yes | conda update --all && conda env export > environment_$(hostname).yaml"
alias nodestartup="npm-check -gy && npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > ~/.node_packages"
alias commonstartup="vimstartup && antibody update && nodestartup; pythonstartup"
alias fzf="fzf --bind '~:execute(nvim {})'"
if [[ -d /apollo/env ]] ; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  export PATH=/home/linuxbrew/.linuxbrew/sbin:$PATH
  export PATH=/home/linuxbrew/.linuxbrew/opt/ccache/libexec:$PATH
  if [[ ! -d /home/linuxbrew ]] ; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    grep -Ev 'lib|xdpyinfo|antibody|xorg|xtrans' ~/.brew_packages | xargs brew install
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
  alias brewstartup="brew update && brew upgrade && brew list > .brew_packages"
  alias yumstartup="cd ~ && gl && kinit -f && yes | sudo yum update && yes | sudo yum upgrade && brewstartup && commonstartup"
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
export UNAME=$(uname)
