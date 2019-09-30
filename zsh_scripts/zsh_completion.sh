autoload -Uz compinit 
export zcompdump=${HOME}/.zcompdump

re_initialize=0
for match in $zcompdump*(.Nmh+24); do
   re_initialize=1
   break
done

if [[ "$re_initialize" -eq "1" ]] ; then
   compinit;
   compdump;
else
  # omit the check for new functions since we updated today
  compinit -C;
fi


[[ -d $HOME/mozilla_unified ]] && autoload bashcompinit && bashcompinit && source $HOME/mozilla_unified/python/mach/bash-completion.sh
