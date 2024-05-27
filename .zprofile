export LANG=en_US.UTF-8

export CARGO_HOME=$HOME/.cargo
export VENVS=$HOME/.venvs
export P=$HOME/projects
export GOPATH=$P/go
export HTML_TIDY=$HOME/.config/tidy/config.txt
export VOLTA_HOME=$HOME/.volta
export XDG_CONFIG_HOME=$HOME/.config
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=/usr/local/opt/mysql-client/bin:$PATH

if [ -e /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -e /usr/local/Homebrew/bin/brew ]; then
  eval "$(/usr/local/Homebrew/bin/brew shellenv)"
fi

export PATH=$HOME/.amplify/bin:$PATH
export PATH=$HOME/.cabal/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.nimble/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$VOLTA_HOME/bin:$PATH

export PATH=$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH
export PATH=$HOME/.emacs.d/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/bin:$PATH

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

if command -v jenv 1>/dev/null 2>&1; then
  eval "$(jenv init -)"
  jenv enable-plugin export >/dev/null
fi
