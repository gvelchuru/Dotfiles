if [[ $UNAME =~ "Linux" ]]; then
    export CONDA_SCRIPT_NAME=Miniconda3-latest-Linux-x86_64.sh
    export CONDA_EXEC=". $HOME/miniconda3/etc/profile.d/conda.sh"
elif [[ $UNAME =~ "Darwin" ]];then
    export CONDA_SCRIPT_NAME=Miniconda3-latest-MacOSX-x86_64.sh
    export CONDA_EXEC="$(/usr/local/bin/conda shell.zsh hook)"
fi

function get_conda() {
  if [[ ! -f $HOME/$CONDA_SCRIPT_NAME ]]; then
        wget https://repo.anaconda.com/miniconda/$CONDA_SCRIPT_NAME
  fi
  chmod u+x $HOME/$CONDA_SCRIPT_NAME
  . $HOME/$CONDA_SCRIPT_NAME
  conda create -n dev --file ~/environment_$HOSTNAME.yaml
}

if [[ $IS_BATMOBILE -gt 0 ]]; then
	eval $CONDA_EXEC || (get_conda && eval $CONDA_EXEC)
	[[ -z $TMUX ]] && conda activate dev || conda deactivate; conda activate dev
fi
