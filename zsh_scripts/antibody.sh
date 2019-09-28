antibody_source() {
  antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
}

[[ -f ~/.zsh_plugins.sh ]] || antibody_source
source ~/.zsh_plugins.sh
