export LANG=en_US.UTF-8

export CARGO_HOME=$HOME/.cargo
export VENVS=$HOME/.venvs

export P=$HOME/projects
export GOPATH=$P/go
export G=$GOPATH/src

export BROWSER=/usr/bin/firefox

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.cabal/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/bin:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
