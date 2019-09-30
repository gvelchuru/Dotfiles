if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ ! "$UNAME" =~ "Darwin" ]]; then
  if [ -z $APOLLO_EXISTS ]; then
    exec tmux new-session -A -s main -c /workplace/$(whoami)
  else 
    exec tmux new-session -A -s main 
  fi
fi
