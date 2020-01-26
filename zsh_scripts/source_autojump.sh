if [[ $IS_LINUX -eq 0 ]] ; then
    if [[ $HAS_BREW -eq 0 ]] ; then
        source /home/linuxbrew/.linuxbrew/Cellar/autojump/22.5.3/share/autojump/autojump.zsh
    else  
        source /usr/share/autojump/autojump.zsh || source /etc/profile.d/autojump.zsh || source $HOME/.autojump/etc/profile.d/autojump.sh
    fi
elif [[ $IS_MAC -eq 0 ]] ; then
    . /usr/local/etc/profile.d/autojump.sh
fi
