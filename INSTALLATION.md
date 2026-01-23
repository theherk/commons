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
    sudo xcodebuild -license accept

## Install many tools with brew.

    brew bundle

## Change Shell to Fish.

First, you must add to the "List of acceptable shells". Then you can change to it.

```sh
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install \
    jorgebucaran/fisher \
    PatrickF1/fzf.fish \
    reitzig/sdkman-for-fish
```

### Disabling default fzf search history in favor of PatrickF1/fzf.fish

```fish
(brew --prefix)/opt/fzf/uninstall
```

### Set fish colors without storing themes

```fish
fisher install catppuccin/fish
```

Light dark toggle scripts will set the correct theme.

## Make sure theme caches are built.

Directory `syntaxes` has to exist for silicon to build cache.

```sh
cd ~/.config/bat && mkdir -p syntaxes && bat cache --build && silicon --build-cache
```

## May want to disable press and hold keys globally.

```sh
defaults write -g ApplePressAndHoldEnabled -bool false
```

## Install more programming tools.

### Install Go from https://golang.org/doc/install.

Followed by:

```sh
go install \
    github.com/cweill/gotests/...@latest \
    github.com/fatih/gomodifytags@latest \
    github.com/hashicorp/hcl/v2/cmd/hclfmt@latest \
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

Also install [markdown-toc](https://github.com/pbzweihander/markdown-toc).

```sh
cargo install markdown-toc
```

Gotta have HN.

```sh
cargo install hackernews_tui --locked
```

### Install Java / Tools.

```sh
curl -s https://get.sdkman.io | bash
sdk install java
```

### Some npm tools.

```sh
npm i -g js-beautify stylelint
npm audit fix
npm i --pack-lock-only
npm audit fix # seems to work after package lock
```

### Prepare Python.

> **Note**
>
> With M1 see:
>
> - https://github.com/pyenv/pyenv/issues/1768#issuecomment-871602950
> - https://stackoverflow.com/questions/71577626/issues-installing-python-3-8-10-on-macos-12-3-monterey

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
mkdir -p $P/dnb.ghe.com $P/github.com $P/gitlab.com $P/gitlab.tech.dnb.no
cargo +nightly install git-repo-manager
ln -sf ~/commons/.config/grm/dnb.ghe.com/config.toml $P/dnb.ghe.com/config.toml
ln -sf ~/commons/.config/grm/github.com/config.toml $P/github.com/config.toml
ln -sf ~/commons/.config/grm/gitlab.com/config.toml $P/gitlab.com/config.toml
ln -sf ~/commons/.config/grm/gitlab.tech.dnb.no/config.toml $P/gitlab.tech.dnb.no/config.toml
```

Then, you must store personal access tokens in the keyring.

    pwa dnb.ghe.com adam.lawrence.sherwood@dnb.no
    pwa github.com theherk@gmail.com
    pwa gitlab.com theherk@gmail.com
    pwa gitlab.tech.dnb.no adam.lawrence.sherwood@dnb.no

Lastly, sync the repositories. These could be shared manifests, but for now this granular approach is chosen.

    cd $P/dnb.ghe.com && grm repos sync config
    cd $P/github.com && grm repos sync config
    cd $P/gitlab.com && grm repos sync config
    cd $P/gitlab.tech.dnb.no && grm repos sync config

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

> **Warning**
>
> Sometimes you use `sudo` a lot. A responsible nerd will tell you not to do this, but `¯\_(ツ)_/¯`... Well, I set up an ssh tunnel to proxy for git several times daily so... Look, what I'm trying to say is, "We don't get into this business to input _extra_ keystrokes."

```sh
echo 'h4s ALL = NOPASSWD: /usr/bin/ssh' >> /etc/sudoers
```

> **Warning**
>
> **Last warning!** If you get an error `zsh: permission denied: /etc/sudoers`, and you don't know how to get around it, I implore you; do not do this.

---

Unimportant, completely optional or historical configurations follow.

## Install bitwarden-cli.

I prefer to install bitwarden-cli directly from a download at the source rather that via homebrew, because I get squeamish about it installing via NPM. I sure the controls in place are fine, but... I just have trust issues.

```sh
xh -dF 'https://vault.bitwarden.com/download/?app=cli&platform=macos'
unzip bw*
mv bw ~/bin/
```

## Configure Arc

### Extensions

- [Vimium C](https://chromewebstore.google.com/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg)
- [Bitwarden](https://chromewebstore.google.com/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb)
- [uBlock Origin](https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)
- [SponsorBlock](https://chromewebstore.google.com/detail/sponsorblock-for-youtube/mnjggcdmjocbbbhaepdhchncahnbgone)
- [Dark Reader](https://chromewebstore.google.com/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh)

### Vimium C

#### Custom key mappings

```
map K previousTab
map J nextTab

map o Vomnibar.activate engines="tab=1,bookmark=2"
map O Vomnibar.activateInNewTab engines="tab=1,bookmark=2"
```

#### Custom CSS

This has automatic mode switching for both Catppuccin Frappe and Latte.

```css
/* #ui */

.LH {
  background: #eff1f5;
  color: #1e66f5;
  border: 1px #e64553 solid;
  font-weight: 555;
  scale: 1.23;
}

.D > .LH {
  background: #303446;
  color: #8caaee;
  border-color: #ca9ee6;
}

.HUD::after {
  background: #f2f4f8;
  border-style: none;
}

.HUD.D::after {
  background: #292c3c;
}

/* #omni */

body {
  border: 1px solid #d0d1d7;
  border-radius: 8px;
}

body.has-dark {
  border-color: #414559;
}

#bar {
  background: #f2f4f8;
  border-bottom: 1px solid #d0d1d7;
}

.has-dark #bar {
  background: #292c3c;
  border-bottom-color: #414559;
}

#input {
  background: transparent;
  color: #4c4f69;
  border: none;
  box-shadow: none;
}

.has-dark #input {
  color: #bac2de;
}

#list {
  background: #eff1f5;
}

.has-dark #list {
  background: #303446;
}

.item {
  border: 1px solid transparent;
}

.item.s,
.item:hover {
  border-color: #1e66f5;
  background: rgba(30, 102, 245, 0.12);
}

.has-dark .item.s,
.has-dark .item:hover {
  border-color: #8caaee;
  background: rgba(140, 170, 238, 0.15);
}

.item .top {
  color: #4c4f69;
}

.has-dark .item .top {
  color: #c6d0f5;
}

.item .top .title match {
  color: #e64553;
  font-weight: 600;
}

.has-dark .item .top .title match {
  color: #f4b8e4;
}

.item .bottom a {
  color: #8839ef;
}

.has-dark .item .bottom a {
  color: #ca9ee6;
}

#toolbar .button {
  opacity: 0.6;
}

#toolbar .button:hover {
  opacity: 1;
}

.has-dark #toolbar .button#toggle-dark .i-moon,
.has-dark #toolbar .button#toggle-dark .i-sun {
  fill: #a6d189;
  stroke: #a6d189;
}

.has-dark #toolbar .button#close > svg {
  fill: #bac2de;
  stroke: #bac2de;
}

/* #find */

* {
  font-family: "VictorMono Nerd Font" !important;
  background: unset;
}

.r {
  background: transparent;
  box-shadow: none;
  color: #4c4f69;
}

.r.D {
  background: transparent;
  color: #c6d0f5;
}

/* #find:selection */

::selection {
  background: #e64553 !important;
  color: #eff1f5 !important;
}

.D::selection {
  background: #f4b8e4 !important;
  color: #303446 !important;
}
```
