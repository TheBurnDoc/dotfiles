# Must use Powerline font for \uE0A0 to render

# git
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"

# kubectx
kubectx_mapping[docker-desktop]="%{$reset_color%}%{$fg_bold[green]%}docker%{$reset_color%}"
kubectx_mapping[minikube]="%{$reset_color%}%{$fg_bold[green]%}minikube%{$reset_color%}"

# Prompt
PROMPT='%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)
%(?.%F{green}√.%F{red}?%?) %(!.%F{red}#.%F{green}$) '
RPROMPT='%{$(echotc UP 1)%}$(kubectx_prompt_info)%{$(echotc DO 1)%}'
