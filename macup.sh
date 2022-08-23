ssh-keygen
ssh-add .ssh/id_rsa
git clone git@gitlab.com:theherk/commons.git
mkdir .config projects
./commons/links.sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # install oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install brew
xcode-select --install
# install go from https://golang.org/doc/install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # install rust
go get -u \
    github.com/cweill/gotests/... \
    github.com/fatih/gomodifytags \
    github.com/motemen/gore/... \
    github.com/nsf/gocode \
    golang.org/x/tools/...
brew tap cjbassi/ytop
brew tap homebrew/cask-fonts
brew tap helix-editor/helix
brew tap wez/wezterm
brew install --cask \
    homebrew/cask-fonts/font-victor-mono-nerd-font \
    wez/wezterm/wezterm
brew install \
    archey \
    asciinema \
    aspell \
    bat \
    caddy \
    clang-format \
    coreutils \
    direnv \
    dropbox \
    dua-cli \
    dust \
    editorconfig \
    exa \
    fd \
    fzf \
    ghc \
    git \
    git-delta \
    gitui \
    gnu-units \
    gnupg \
    grip \
    helix \
    jq \
    kubectl \
    lazygit \
    lazydocker \
    mactex \
    markdown \
    navi \
    newman \
    npm \
    onefetch \
    pandoc \
    pinentry-mac \
    plantuml \
    podman \
    postman \
    procs \
    pyenv \
    pygments \
    ripgrep \
    rust-analyzer \
    shadowenv \
    shellcheck \
    sk \
    starship \
    terraform \
    terraform-ls \
    tokei \
    wget \
    xh
npm i -g js-beautify stylelint
npm audit fix
npm i --pack-lock-only
npm audit fix # seems to work after package lock
# With M1, need:
# export PYTHON_CONFIGURE_OPTS="--build=aarch64-apple-darwin20.5.0"
# see: https://github.com/pyenv/pyenv/issues/1768#issuecomment-871602950
pyenv install 3.9.5
pyenv global 3.9.5
pip install black nose pytest pyflakes isort pipenv
rustup toolchain add nightly
cargo +nightly install racer
rustup default nightly
rustup component add rust-src
# install emacs
brew tap d12frosted/emacs-plus
brew install emacs-plus@28 --with-modern-doom3-icon
# ln -s /usr/local/opt/emacs-plus@28/Emacs.app /Applications/
cp -r /usr/local/opt/emacs-plus@28/Emacs.app /Applications/
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d # install doom
doom install
brew services start emacs-plus
# create automator routine emacs-everywhere and bind M-S-space
# can be imported from icloud; basically command script service invoking
# /opt/homebrew/bin/emacsclient --eval "(emacs-everywhere)"
# needs to be full path result of which emacsclient
# install fonts from https://fonts.google.com/specimen/Ubuntu
# install fonts from https://fonts.google.com/specimen/Ubuntu+Mono
brew install --cask fontforge
git clone --recurse-submodules https://github.com/ToxicFrog/Ligaturizer.git
# For my purposes, all fonts listed for processing can be removed aside from
# Ubuntu fonts in Ligaturizer/build.py.
cd Ligaturizer && make && cp fonts/output/* ~/Library/Fonts/
doom sync
# If I install VSCode, this line lets me scroll normally.
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
# Add pinentry for mac into gpg configuration.
echo "pinentry-program /usr/local/bin/pinentry-mac" >>~/.gnupg/gpg-agent.conf
# Install apptivate.
# Setup dropbox org sync.
ln -sf ~/Dropbox/org ~/
