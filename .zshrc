echo "Loading Zsh configuration..."

# Source profile (only once)
if [ -f "$HOME/.zprofile" ] && [ -z "$PROFILE_SOURCED" ]; then
  source "$HOME/.zprofile"
fi

# Oh My Zsh!
if [ -d $HOME/.oh-my-zsh ]; then
    ZSH_THEME="half-life"
    plugins=(git dotenv pyenv virtualenv)
    export ZSH="$HOME/.oh-my-zsh"
    source $ZSH/oh-my-zsh.sh
fi

# Terraform
if (( $+commands[terraform] )); then
    complete -o nospace -C $(which terraform) terraform
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
