export PATH="$HOME/.pyenv/bin:$PATH"
if (( ! $+commands[pyenv] )) ; then
  curl https://pyenv.run | zsh
  git clone https://github.com/momo-lab/xxenv-latest.git $PYENV_LATEST_LOCATION
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
