if [[ ! -f $HOME/miniconda3/etc/profile.d/conda.sh ]]; then
    if [[ $UNAME =~ "Linux" ]]; then
        if [[ ! -f $HOME/Miniconda3-latest-Linux-x86_64.sh ]]; then
            wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
        fi
        chmod u+x ~/Miniconda3-latest-Linux-x86_64.sh
        . $HOME/Miniconda3-latest-Linux-x86_64.sh
        conda env create --name=dev --file=~/environment_$(hostname).yaml
    fi
fi
if [[ $UNAME =~ "Linux" ]]; then
    . $HOME/miniconda3/etc/profile.d/conda.sh
fi
[[ -z $TMUX ]] && conda activate dev || conda deactivate; conda activate dev
