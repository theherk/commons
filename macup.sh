ssh-keygen
ssh-add .ssh/id_rsa
git clone git@gitlab.com:theherk/commons.git
mkdir .config projects
./commons/links.sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # install oh-my-zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install brew
xcode-select --install
# install go from https://golang.org/doc/install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # install rust
go get -u \
    github.com/cweill/gotests \
    github.com/fatih/gomodifytags \
    github.com/motemen/gore \
    github.com/nsf/gocode \
    golang.org/x/tools/...
# brew tap homebrew/cask-fonts
brew install \
    archey \
    aspell \
    coreutils \
    direnv \
    editorconfig \
    direnv \
    fd \
    font-ubuntu-nerd-font \
    ghc \
    git \
    jq \
    kubectl \
    markdown \
    npm \
    plantuml \
    ripgrep \
    shadowenv \
    spellcheck \
    starship \
    terraform \
    wget

npm i -g js-beautify
npm i -g stylelint
npm audit fix
npm i --pack-lock-only
npm audit fix # seems to work after package lock
rustup toolchain add nightly
cargo +nightly install racer # maybe fail
# install emacs
brew tap d12frosted/emacs-plus
brew install emacs-plus --HEAD --with-modern-doom3-icon
ln -s /usr/local/opt/emacs-plus@27/Emacs.app /Applications/
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d # install doom
doom install
# install fonts from https://fonts.google.com/specimen/Ubuntu
# install fonts from https://fonts.google.com/specimen/Ubuntu+Mono
doom sync
