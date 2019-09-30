if command -v tmux &> /dev/null && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ ! "$UNAME" =~ "Darwin" ]]; then
  if [[ $APOLLO_EXISTS -eq 0 ]]; then
    exec tmux new-session -A -s main -c /workplace/$(whoami)
  else 
    exec tmux new-session -A -s main 
  fi
fi
