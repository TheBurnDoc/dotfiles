# Local paths
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh! init
ZSH_THEME="avit"
plugins=(git dotenv kubectl kubectx)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Default editor
export VISUAL=vim
export EDITOR=vim

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then

    # iTerm2 shell integration
    if [ -f $HOME/.iterm2_shell_integration.zsh ]; then
        source /Users/tim/.iterm2_shell_integration.zsh
    fi

    # Homebrew
    if (( $+commands[brew] )); then
        export PATH=$(brew --prefix)/bin:$PATH
        export CPATH=$(brew --prefix)/include:$CPATH
        export LIBRARY_PATH=$(brew --prefix)/lib:$LIBRARY_PATH
        export HOMEBREW_NO_ENV_HINTS=1
        export HOMEBREW_NO_AUTO_UPDATE=1
    fi

    if [ -d $HOME/Library/Python/3.9 ]; then
        export PATH=$HOME/Library/Python/3.9/bin:$PATH
    fi

    export DYLD_LIBRARY_PATH=$LIBRARY_PATH:$DYLD_LIBRARY_PATH

# Non macOS systems
else

    # Shared settings on all non-macOS
    export PATH=/usr/local/bin:$PATH
    export CPATH=/usr/local/include:$CPATH
    export LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
    export LD_LIBRARY_PATH=$LIBRARY_PATH:$LD_LIBRARY_PATH

    # Linux specific
    if [[ "$OSTYPE" == "linux-gnu" ]]; then

        # Wine configuration
        export WINEARCH=win32
        export WINEPREFIX=~/.wine/win32

    fi
fi

# Golang
if (( $+commands[go] )); then
    export GOPATH=~/.local/go
    export PATH=$PATH:$GOPATH/bin
fi

# Terraform
if (( $+commands[terraform] )); then
    complete -o nospace -C $(which terraform) terraform
fi

# Kubernetes
if (( $+commands[kubectl] )); then
    if (( $+commands[kubectx] )); then
        alias kx='kubectx'
    fi
    _CTX='echo "Kubernetes Context: $(kubectl config current-context)";'$_CTX
fi

# Azure
if (( $+commands[az] )); then
    _CTX='echo "Azure Subscription: $(az account show | jq -r .name)";'$_CTX
fi

# Context summary
alias ctx='eval $_CTX'

# Misc. aliases and functions
alias ws='cd ~/Workspace'
alias -s {go,md,yml,yaml,tf,Dockerfile}=code
mkcd() { mkdir -p $1 && cd $1 }

