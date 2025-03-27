echo "Loading Zsh profile..."
export PROFILE_SOURCED=1

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
    export HOMEBREW_NO_ENV_HINTS=1
fi

# Vim
if (( $+commands[vim] )); then
    export VISUAL='vim'
    export EDITOR=$VISUAL
fi

# Java (Jenv)
if (( $+commands[jenv] )); then
    export PATH=$HOME/.jenv/bin:$(jenv prefix)/bin:$PATH
    eval "$(jenv init -)"
fi

# Python (Pyenv)
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
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

# Lua Rocks
if (( $+commands[luarocks] )); then
    eval "$(luarocks path)"
fi

# Rancher Desktop
if [ -d "$HOME/.rd" ]; then
    export PATH=$HOME/.rd/bin:$PATH
fi