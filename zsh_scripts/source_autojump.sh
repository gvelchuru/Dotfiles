if [[ $IS_LINUX -eq 0 ]] ; then
    if [[ $IS_BATMOBILE -eq 0 || $IS_BATCAVE -eq 0 ]]; then
        source /usr/share/autojump/autojump.zsh || source /etc/profile.d/autojump.zsh || source $HOME/.autojump/etc/profile.d/autojump.sh
    elif [[ $HAS_BREW -eq 0 ]] ; then
        source /home/velchug/.autojump/etc/profile.d/autojump.sh
    fi
elif [[ $IS_MAC -eq 0 ]] ; then
    . /usr/local/etc/profile.d/autojump.sh
fi
