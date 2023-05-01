HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
unsetopt beep
autoload -Uz compinit && compinit

ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"
plugins=(
    aws
    brew
    fzf
    golang
    ripgrep
    rust
    terraform
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)

export EDITOR='lvim'
export PAGER="less -FRSX"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"

source $HOME/.aliases
source $HOME/.functions

eval "$(direnv hook zsh)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(shadowenv init zsh)"
eval "$(starship init zsh)"

# [ -s "/Users/h4s/.jabba/jabba.sh" ] && source "/Users/h4s/.jabba/jabba.sh"
