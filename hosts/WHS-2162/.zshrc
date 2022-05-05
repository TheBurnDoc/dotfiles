export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh! init
ZSH_THEME="robbyrussell"
plugins=(git kubectl kubectx)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Homebrew config
export HOMEBREW_NO_ENV_HINTS=1

# Go config
export GOPATH=~/.local/go
export PATH=$PATH:$GOPATH/bin

# Kubectx prompt
kubectx_mapping[minikube]="%{$reset_color%}%{$fg[green]%}minikube%{$reset_color%}"
PROMPT='%{$fg[yellow]%}$(kubectx_prompt_info)%{$reset_color%} '$PROMPT

# Aliases
alias ws='cd ~/Workspace'
alias kx='kubectx'
alias azx="az aks list | jq '.[].dnsPrefix'"

# Suffix aliases
alias -s {sh,zsh,go,md,yml,yaml,tf,Dockerfile}=code

# Functions
mkcd() { mkdir -p $1 && cd $1 }
