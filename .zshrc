# Variables
export WORKSPACE=$(find $HOME -maxdepth 1 -iname workspace -type d)
export CDPATH=$WORKSPACE:$WORKSPACE/github.com:$WORKSPACE/gitlab.com
export PATH=$HOME/.local/bin:$WORKSPACE/_local/scripts:/usr/local/bin:$PATH
export CPATH=$HOME/.local/include:$CPATH
export LIBRARY_PATH=$HOME/.local/lib:$LIBRARY_PATH

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then

    # iTerm2
    if [ -f $HOME/.iterm2_shell_integration.zsh ]; then
        source $HOME/.iterm2_shell_integration.zsh
    fi

    # Homebrew
    if [ -d /opt/homebrew ]; then
        export PATH=/opt/homebrew/bin:$PATH
    fi

# Linux specific
elif [[ "$OSTYPE" == "linux-gnu" ]]; then

    # Wine configuration
    export WINEARCH=win32
    export WINEPREFIX=~/.wine/win32

     # Homebrew
    if [ -d /home/linuxbrew/.linuxbrew ]; then
        export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
    fi   
fi

# Homebrew
if (( $+commands[brew] )); then
    export PATH=$(brew --prefix)/bin:$PATH
    export CPATH=$(brew --prefix)/include:$CPATH
    export LIBRARY_PATH=$(brew --prefix)/lib:$LIBRARY_PATH
    export LD_LIBRARY_PATH=$(brew --prefix)/lib:$LD_LIBRARY_PATH
fi

# Vim
if (( $+commands[vim] )); then
    export VISUAL='vim'
    export EDITOR=$VISUAL
fi

# Oh My Zsh!
if [ -d $HOME/.oh-my-zsh ]; then
    ZSH_THEME="half-life"
    plugins=(git dotenv)
    export ZSH="$HOME/.oh-my-zsh"
    source $ZSH/oh-my-zsh.sh
fi

# Java (Jenv)
if (( $+commands[jenv] )); then
    export PATH=$HOME/.jenv/bin:$(jenv prefix)/bin:$PATH
    eval "$(jenv init -)"
fi

# Golang
if [ -d /usr/local/go ]; then
    export GOPATH=$HOME/.local/go
    export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
fi

# Cargo (Rust)
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Terraform
if (( $+commands[terraform] )); then
    complete -o nospace -C $(which terraform) terraform
fi

# Rancher Desktop
if [ -d "$HOME/.rd" ]; then
    export PATH=$HOME/.rd/bin:$PATH
fi

# Kubernetes
if (( $+commands[kubectl] )); then
    _CTX='echo "Kubernetes Context: $(kubectl config current-context)";'$_CTX

    # Tool completions
    (( $+commands[stern] )) && source <(stern --completion=zsh)
    (( $+commands[argocd] )) && source <(argocd completion zsh)

    # Depends on kubectx plugin
    if (( $+commands[kubectx] )); then
        alias kx='kubectx'
        RPROMPT=$RPROMPT'%{$(echotc UP 1)%} $(kubectx_prompt_info)%{$(echotc DO 1)%}'
        for ctx in $(kx | grep -i prod); do
            kubectx_mapping[$ctx]="%{$bg[red]%}%{$fg[yellow]%} $ctx PROD! %{$reset_color%}"
        done
    fi
fi

# AWS
if (( $+commands[aws] )); then
    _CTX='echo AWS Account: $(aws iam list-account-aliases --output json | jq -r ".AccountAliases[0]");'$_CTX
    (( $+commands[aws_completer] )) && complete -C aws_completer aws
    (( $+commands[fzf] )) && alias awsp='export AWS_PROFILE=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | fzf)'
fi

# Azure
if (( $+commands[az] )); then
    _CTX='echo "Azure Subscription: $(az account show | jq -r .name)";'$_CTX
fi

# GCP
if (( $+commands[gcloud] )); then
    _CTX='echo "GCP Project: $(gcloud config get-value project)";'$_CTX
fi


# Aliases and functions
alias ctx='eval $_CTX'
mkcd() { mkdir -p $1 && cd $1 }
alias ..='cd ..'

# Source local files
if [ -d $HOME/.local/zshrc.d ]; then
    for file in $HOME/.local/zshrc.d/*; do
	source "$file"
    done
fi