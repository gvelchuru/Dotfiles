if [[ -e /etc/profile.d/autojump.zsh ]] ; then
    source /etc/profile.d/autojump.zsh
elif [[ -e /home/linuxbrew ]] ; then
    source /home/linuxbrew/.linuxbrew/Cellar/autojump/22.5.3/share/autojump/autojump.zsh
else
    source $HOME/.autojump/etc/profile.d/autojump.sh
fi
