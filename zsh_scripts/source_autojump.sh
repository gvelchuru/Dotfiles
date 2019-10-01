if [[ -f /etc/profile.d/autojump.zsh ]] ; then
    source /etc/profile.d/autojump.zsh
elif [[ -d /home/linuxbrew ]] ; then
    source /home/linuxbrew/.linuxbrew/Cellar/autojump/22.5.3/share/autojump/autojump.zsh
elif [[ -f /usr/local/etc/profile.d/autojump.sh ]] ; then
    . /usr/local/etc/profile.d/autojump.sh
else
    source $HOME/.autojump/etc/profile.d/autojump.sh
fi
