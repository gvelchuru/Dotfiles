if command -v tmux &> /dev/null && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ ! "$UNAME" =~ "Darwin" ]]; then
  if [[ $APOLLO_EXISTS -eq 0 ]]; then
    exec tmux new-session -A -s main -c /workplace/$(whoami)
  fi
fi

#elif [[ $IS_EC2 -eq 0 ]]; then
#exec tmux new-session -A -s main
