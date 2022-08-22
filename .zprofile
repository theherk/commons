export LANG=en_US.UTF-8

export CARGO_HOME=$HOME/.cargo
export VENVS=$HOME/.venvs
export P=$HOME/projects
export GOPATH=$P/go
export JAVA_HOME=$(/usr/libexec/java_home)

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=/usr/local/opt/mysql-client/bin:$PATH
export PATH=$HOME/.amplify/bin:$PATH
export PATH=$HOME/.cabal/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.nimble/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
export PATH=$HOME/.emacs.d/bin:$PATH
export PATH=$HOME/bin:$PATH

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
