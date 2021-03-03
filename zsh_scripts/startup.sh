setopt NO_BEEP

export UNAME=$(uname)
[[ $UNAME =~ "Linux" ]];export IS_LINUX=$?
[[ $UNAME =~ "Darwin" ]];export IS_MAC=$?
[[ -d /apollo/env ]];export APOLLO_EXISTS=$?
[[ -d /home/linuxbrew ]];export HAS_BREW=$?
[[ -d $HOME/.cargo ]];export HAS_RUST=$?
[[ $IS_LINUX -eq 0 ]] && [[ $APOLLO_EXISTS -gt 0 ]] && [[ $(hostname) != "batmobile" ]];export IS_EC2=$?

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

alias commonstartup="topgrade && nvim +CocUpdateSync +qa"
alias fzf="fzf --bind '~:execute(nvim {})'"

export PATH=$HOME/.local/bin:$PATH
if [[ $IS_MAC -eq 0 ]] ; then
  alias startup="cd ~ && commonstartup"
  alias sshcrate='ssh dev-dsk-velchug-2a-f5267e62.us-west-2.amazon.com -R 2000:localhost:2000'
  alias moshcrate='mosh --server=/home/linuxbrew/.linuxbrew/bin/mosh-server  dev-dsk-velchug-2a-d0d24224.us-west-2.amazon.com'
  export PATH="$PATH:/Users/velchug/.dotnet/tools"
  alias mac_copy="nc -l 2000 | pbcopy"
elif [[ $IS_EC2 -eq 0 ]] ; then
  brew_startup
  alias startup="cd ~ && commonstartup"
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/x86_64-linux-gnu/pkgconfig
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/share/pkgconfig
  export PATH=/usr/lib/ccache/bin:$PATH
  export PATH=/usr/local/opt/ccache/libexec:$PATH
  export PATH=$HOME/go/bin:$PATH
fi
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-denisidoro-SLASH-navi:$PATH
