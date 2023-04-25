# Installation

## Get this repository from git.

### For you:

    git clone https://github.com/theherk/commons.git ~/commons

### For me:

    ssh-keygen -t ed25519
    ssh-add .ssh/id_ed25519.pub

Then add this key to Github. Followed by:

    git clone git@github.com:theherk/commons.git ~/commons

## Install [Homebrew](https://brew.sh/).

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install zsh.

    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # install oh-my-zsh
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

## Add soft links.

    mkdir -p .config projects
    ./commons/links.sh

That will link all the configurations where they need to be. Then we just need to set about installing things. This is tailored to MacOS, since that is what I use nearly always, now.

    xcode-select --install

## Install many tools with brew.

```sh
brew tap cjbassi/ytop
brew tap homebrew/cask-fonts
brew tap helix-editor/helix
brew tap wez/wezterm
brew install --cask \
    homebrew/cask-fonts/font-victor-mono-nerd-font \
    keepingyouawake \
    keycastr \
    vscodium \
    wez/wezterm/wezterm
brew install \
    asciinema \
    aspell \
    bat \
    bottom \
    caddy \
    clang-format \
    coreutils \
    direnv \
    diskonaut \
    doll \
    dropbox \
    dua-cli \
    dust \
    editorconfig \
    exa \
    fd \
    fish \
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
    pyenv-virtualenv \
    pygments \
    ripgrep \
    rust-analyzer \
    shadowenv \
    shellcheck \
    sk \
    starship \
    temurin \
    terraform \
    terraform-ls \
    tokei \
    translate-shell \
    wget \
    xh \
    zellij \
    zenith
```

## Change Shell to Fish.

First, you must add to the "List of acceptable shells". Then you can change to it.

```sh
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install \
    jorgebucaran/fisher \
    PatrickF1/fzf.fish
```

## Setup Codium

Adding a setup for [VSCodium](https://vscodium.com/) because the AI integration is tighter for now. As I am evaluating [Codeium](https://codeium.com/), [CodeWhisperer](https://aws.amazon.com/codewhisperer/), and [Copilot](https://github.com/features/copilot), I need to test the various integrations. I'm not quite ready to transition completely. ❤️ Emacs.

First, get it out of quarantine.

    xattr -d com.apple.quarantine /Applications/VSCodium.app/

Then install extensions.

```sh
echo "
alefragnani.project-manager
belfz.search-crates-io
bierner.emojisense
bmalehorn.vscode-fish
bodil.file-browser
Codeium.codeium
DaltonMenezes.aura-theme
eamodio.gitlens
EditorConfig.EditorConfig
enkia.tokyo-night
esbenp.prettier-vscode
foam.foam-vscode
garlandcrow.vscode-helix
golang.go
Gruntfuggly.todo-tree
hashicorp.hcl
hashicorp.terraform
jacobdufault.fuzzy-search
jdinhlife.gruvbox
kahole.magit
mikoz.black-py
ms-python.python
ms-toolsai.jupyter
ms-toolsai.jupyter-keymap
ms-toolsai.jupyter-renderers
ms-toolsai.vscode-jupyter-cell-tags
ms-toolsai.vscode-jupyter-slideshow
PKief.material-icon-theme
rust-lang.rust-analyzer
slbtty.Lisp-Syntax
vscode-org-mode.org-mode
vscodevim.vim
VSpaceCode.vspacecode
VSpaceCode.whichkey
ziglang.vscode-zig
" | xargs -L 1 codium --install-extension
```

Disable the native press-and-hold behavior for the vim plugin. This is a different command than given in the documentation, and can be found in [this issue](https://github.com/VSCodeVim/Vim/issues/8052#issuecomment-1422383241) and [this StackOverflow answer](https://stackoverflow.com/a/73897433/2081835).

    defaults write com.vscodium ApplePressAndHoldEnabled -bool false

## Install Emacs.

There are slight differences in amd64 and arm64 paths.

```sh
brew tap d12frosted/emacs-plus
brew install emacs-plus@29 --with-memeplex-slim-icon --with-native-comp --with-xwidgets --with-imagemagick
cp -r /opt/homebrew/opt/emacs-plus@29/Emacs.app /Applications/
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d # install doom
doom install
brew services start emacs-plus
# create automator routine emacs-everywhere and bind M-S-space
# can be imported from icloud; basically command script service invoking
# /opt/homebrew/bin/emacsclient --eval "(emacs-everywhere)"
# needs to be full path result of which emacsclient
doom sync
ln -sf ~/Dropbox/org ~/
ln -sf ~/commons/.config/ispell/ ~/.emacs.d/.local/etc/
```

### Add pinentry for mac into gpg configuration.

    echo "pinentry-program $(which pinentry-mac)" >>~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent

## Install more programming tools.

### Install Go from https://golang.org/doc/install.

Followed by:

```sh
go install \
    github.com/cweill/gotests/...@latest \
    github.com/fatih/gomodifytags@latest \
    github.com/x-motemen/gore/...@latest \
    github.com/nsf/gocode@latest \
    golang.org/x/tools/...@latest
```

### Install Rust.

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # install rust
rustup toolchain add nightly
cargo +nightly install racer
rustup default nightly
rustup component add rust-src rustc-dev llvm-tools-preview
```

### Some npm tools.

```sh
npm i -g js-beautify stylelint
npm audit fix
npm i --pack-lock-only
npm audit fix # seems to work after package lock
```

### Prepare Python.

!!!
    With M1 see:
    - https://github.com/pyenv/pyenv/issues/1768#issuecomment-871602950
    - https://stackoverflow.com/questions/71577626/issues-installing-python-3-8-10-on-macos-12-3-monterey

```sh
pyenv install 3.9.11
pyenv install 3.10.3
pyenv global 3.10.3
pip install black isort keyring nose pipenv pyflakes pyppeteer pytest
```

## Setup git forge.

This is an optional step, and will merge all owner repositories to their correct homes in `~/projects/`.

First, ensure the requisite directories exist, install [git-repo-manager](https://github.com/hakoerber/git-repo-manager), and link the configuration files into the correct locations.

```sh
mkdir -p $P/github.com $P/gitlab.com
cargo +nightly install git-repo-manager
ln -sf ~/commons/.config/grm/github.com/config.toml $P/github.com/config.toml
ln -sf ~/commons/.config/grm/gitlab.com/config.toml $P/gitlab.com/config.toml
```

Then, you must store personal access tokens in the keyring.

    pwa github.com theherk@gmail.com
    pwa gitlab.com theherk@gmail.com

Lastly, sync the repositories. These could be shared manifests, but for now this granular approach is chosen.

    cd $P/github.com && grm repos sync config
    cd $P/gitlab.com && grm repos sync config

## MacOS windows manager

### Dock

```sh
defaults write com.apple.dock tilesize -float 32
defaults read com.apple.dock orientation -string right
defaults write com.apple.dock autohide -bool true
killall Dock
```

### Notifications

Since the dock is usually hidden, use [Doll](https://github.com/xiaogdgenuine/Doll) to load apps into menu bar.

## Here be dagrons (with consummate V's of course).

!!! WARNING
    Sometimes you use `sudo` a lot. A responsible nerd will tell you not to do this, but `¯\_(ツ)_/¯`... Well, I set up an ssh tunnel to proxy for git several times daily so... Look, what I'm trying to say is, "We don't get into this business to input *extra* keystrokes."

```sh
    echo 'h4s ALL = NOPASSWD: /usr/bin/ssh' >> /etc/sudoers
```

If you get an error `zsh: permission denied: /etc/sudoers`, and you don't know how to get around it, I implore you; do not do this.

