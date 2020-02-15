setopt NO_BEEP

export UNAME=$(uname)
[[ $UNAME =~ "Linux" ]];export IS_LINUX=$?
[[ $UNAME =~ "Darwin" ]];export IS_MAC=$?
[[ -d /apollo/env ]];export APOLLO_EXISTS=$?
[[ -d /home/linuxbrew ]];export HAS_BREW=$?
[[ -d $HOME/.cargo ]];export HAS_RUST=$?
[[ $IS_LINUX -eq 0 ]] && [[ $APOLLO_EXISTS -gt 0 ]] && [[ $(hostname) != "batcave" ]] && [[ $(hostname) != "batmobile" ]];export IS_EC2=$?

if [[ $APOLLO_EXISTS -eq 0 ]] ; then
    export HOSTNAME="apollo"
elif [[ $IS_MAC -eq 0 ]]; then
    export HOSTNAME="mac"
elif [[ $IS_EC2 -eq 0 ]]; then
    export HOSTNAME="ec2"
else
    export HOSTNAME=$(hostname)
fi

[[ $HOSTNAME =~ "batmobile" ]]; export IS_BATMOBILE=$?
[[ $HOSTNAME =~ "batcave" ]]; export IS_BATCAVE=$?
export BREW_PACKAGES=$HOME/.brew_$HOSTNAME\_packages
export BREW_CASKS=$HOME/.brew_$HOSTNAME\_casks
export SPOTINST_KEY="92fb104ae0051d0d85b8f72bbb7acc7cd78efac9ff5018c30838d59f05936685"

if [[ $IS_LINUX -eq 0 ]]; then
  export NUM_CORES=$(nproc)
elif [[ $IS_MAC -eq 0 ]] ; then
  export NUM_CORES=$(sysctl -n hw.ncpu)
fi

brew_startup() {
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  export PATH=/home/linuxbrew/.linuxbrew/sbin:$PATH
  export PATH=/home/linuxbrew/.linuxbrew/opt/ccache/libexec:$PATH
  if [[ $HAS_BREW -gt 0 ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    grep -Ev 'lib|xdpyinfo|antibody|xorg|xtrans' $BREW_PACKAGES | xargs brew install
    if [[ $IS_LINUX -gt 0 ]]; then
      grep -Ev 'lib|xdpyinfo|antibody|xorg|xtrans' $BREW_CASKS | xargs brew install cask
    fi
    brew install getantibody/tap/antibody
  fi
}

tmux_startup() {
  if [[ $APOLLO_EXISTS -eq 0 ]]; then
    tmux new-session -A -s ${1:-main} -c /workplace/$(whoami)
  else
    tmux new-session -A -s ${1:-main}
  fi
}

kinit_loop() {
  until kinit -f
  do 
    echo "Try kinit again"
  done
}

alias vimstartup="nvim --headless +PlugInstall +PlugUpdate +PlugUpgrade +qa"
alias pythonstartup="yes | conda update --all && yes | conda update -n base -c defaults conda && conda env export > environment_$HOSTNAME.yaml && pipx upgrade-all"
alias nodestartup="npm-check -gy  && npm list --global --parseable --depth=1 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > ~/.node_$HOSTNAME\_packages"
alias commonstartup="vimstartup && antibody_source && antibody update && nodestartup"
alias brewstartup="brew update; brew upgrade; brew cask upgrade; brew list > $BREW_PACKAGES; brew cask ls > $BREW_CASKS"
alias fzf="fzf --bind '~:execute(nvim {})'"
alias git_init="gl && git submodule update --recursive --remote"
alias yumstartup="yes | sudo yum update && yes | sudo yum upgrade"
alias aptstartup="sudo apt -y update && sudo apt -y upgrade && sudo snap refresh"
alias ruststartup="rustup update"

export PATH=$HOME/.local/bin:$PATH
if [[ $APOLLO_EXISTS -eq 0 ]]; then
  brew_startup
  for d in /apollo/env/*; do
    export PATH=$d/bin:$PATH
  done
  export PATH=$HOME/.toolbox/bin:$PATH
  export BRAZIL_COLORS=1
  export MANPATH=$ENV_IMPROVEMENT_ROOT/man:$ENV_IMPROVEMENT_ROOT/share/man:${MANPATH:-}:/usr/kerberos/man:$MANPATH
  export P4CONFIG=.p4config  # see wiki/?P4CONFIG
  export P4EDITOR=$EDITOR        # editor used for perforce forms (submit, etc)
  export SYSSCREENRC=$ENV_IMPROVEMENT_ROOT/var/screenrc
  export USE_CACHE_WRAPPER=true  #turn on caching for various amazon completions
  export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short # Use short workspace layout in Brazil
  export BRAZIL_PLATFORM_OVERRIDE=AL2012
  export EC2_ACCESS_KEY=$(/apollo/env/envImprovement/bin/odin-get -n -t Principal com.amazon.ebs-server.gameday)
  export EC2_SECRET_KEY=$(/apollo/env/envImprovement/bin/odin-get -n -t Credential com.amazon.ebs-server.gameday)
  alias bb='bear -a brazil-build'
  alias bre='brazil-runtime-exec'
  alias startup="cd ~ && git_init && kinit_loop && yumstartup && brewstartup && commonstartup; pythonstartup && toolbox update"
  alias mac_paste="tmux save-buffer - | nc localhost 2000"
elif [[ $IS_MAC -eq 0 ]] ; then
  alias startup="cd ~ && git_init && mwinit -o && brewstartup && commonstartup; pythonstartup"
  alias sshcrate='ssh dev-dsk-velchug-2a-d0d24224.us-west-2.amazon.com -R 2000:localhost:2000'
  alias moshcrate='mosh --server=/home/linuxbrew/.linuxbrew/bin/mosh-server  dev-dsk-velchug-2a-d0d24224.us-west-2.amazon.com'
  export PATH="$PATH:/Users/velchug/.dotnet/tools"
  alias mac_copy="nc -l 2000 | pbcopy"
elif [[ $IS_EC2 -eq 0 ]] ; then
  brew_startup
  alias startup="cd ~ && git_init && aptstartup && brewstartup && commonstartup"
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/x86_64-linux-gnu/pkgconfig
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/share/pkgconfig
  export PATH=$HOME/.mozbuild/arcanist/bin:$PATH
  export PATH=$HOME/.mozbuild/moz-phab:$PATH
  export PATH=$HOME/.mozbuild/git-cinnabar:$PATH
  export PATH=/usr/lib/ccache/bin:$PATH
  export PATH=$HOME/go/bin:$PATH
elif [[ $IS_BATMOBILE -eq 0 ]] ; then
  brew_startup
  alias startup="cd ~ && aptstartup && git_init && commonstartup; brewstartup"
  alias startup_backup="startup && backup"
  export BORG_REPO='/home/gauthv/Insync/gauthv@cs.washington.edu/google_drive/batmobile_backup'
  alias backup="sudo sh /home/gauthv/backup.sh && insync_restart"
  alias insync_restart="pkexec 'chown -R gauthv:users $BORG_REPO' && killall insync; insync start"
else
  brew_startup
  export PATH=/usr/lib/ccache/bin:$PATH
  #alias startup="cd ~ && git_init && killall insync && insync start && yay -Syu --devel --sudoloop && commonstartup; pythonstartup"
  alias startup="cd ~ && git_init && aptstartup && commonstartup; pythonstartup && brewstartup"
  alias startup_backup="startup && backup"
  alias backup="sudo sh /home/gauthv/backup.sh && insync_restart"
  alias insync_restart="pkexec 'chown -R gauthv:users /mnt/data1/gdrive/batcave_backup' && killall insync; insync start"
fi
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-denisidoro-SLASH-navi:$PATH
