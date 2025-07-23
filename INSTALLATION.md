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
brew tap wez/wezterm

brew install asciinema atuin bash-language-server bat bottom caddy clang-format cmatrix coreutils direnv diskonaut doll dropbox dua-cli dust editorconfig eza fd fish flashspace font-victor-mono-nerd-font fzf ghc git git-delta gitui gnu-units gnupg grip jj jjui jordanbaird-ice jq keycastr kubectl lazygit lazydocker llvm mactex markdown navi nikitabobko/tap/aerospace homebrew/cask/neovide npm nvim onefetch pandoc pngpaste pinentry-mac lhvy/tap/pipes-rs plantuml podman postman procs pyenv pyenv-virtualenv pygments ripgrep rust-analyzer shellcheck silicon sk starship terraform-ls tfenv tokei translate-shell ugit wez/wezterm/wezterm wget yazi xh zed zellij zen-browser zoxide
```

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

## Configure Neovim

My configuration is largely built by cribbing from the legend folke, but it is bespoke to me, and doesn't require other installation. After linking, just fire it up.

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

```css
/* #ui */

.LH {
  background: #e6e9ef;
  color: #04a5e5;
  border-color: #dd7878;
  font-weight: 555;
  scale: 1.23;
}

.D > .LH {
  background: #1a1b26;
  color: #2ac3de;
  border-color: #bb9af7;
}

/* #omni */

#bar {
  background: #ccd0da;
}

.has-dark #bar {
  background: #1a1b26;
}

#input {
  background: #e6e9ef;
  border-color: #dd7878;
}

.has-dark #input {
  background: #24283b;
  border-color: #bb9af7;
}

.history {
  fill: #fe640b;
}

.has-dark .history {
  fill: #e0af68;
}

.icon {
  fill: #04a5e5;
}

.has-dark .icon {
  fill: #e0af68;
}
```

catppuccin version from: https://github.com/catppuccin/vimium/issues/2#issuecomment-1453367965

```css
/*
vimium cattpuccin-frappe theme

Adaped from css code by:
(c) 2020 Saïd Dermoumi
https://github.com/dermoumi/vimium-snow
*/

/* #ui */
/* ^ do not touch this line ^ */


/* .R,.DHM,.HM,.IHS,.IH,.BH,.MH {
    color: #c6d0f5;
    background: #292c3c;
} */

/* link hints */
.LH {
  border: 2px #eebebe solid;
  background: #292c3c;
  margin-top: -2px;
  margin-left: -2px;
  color: #c6d0f5;
  z-index: 0;
  box-shadow: 0px 2px 11px rgb(0, 0, 0, 0.12);
  font-weight: 555;
  scale: 1.23;
}

.LH:before {
  position: absolute;
  background: #292c3c;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  content: "";
  z-index: -1;
}

.D .LH {
  border-color: #eebebe;
  color: #c6d0f5;
}

/* hints matching chars */
.MC {
  color: #e78284;
}

.D .MC {
  color: #e78284;
}

/* bottom hud */
.HUD {
  bottom: 1rem;
  left: unset;
  right: 1rem;
  border: 1px #eebebe solid;
  border-radius: 6px;
  box-shadow: 0 3px 10px #232634;
  padding: 0.5rem 1rem;
  height: 1.5rem !important;
  line-height: 21px;
  text-transform: lowercase;
  background: #292c3c
  color: #c6d0f5;
  max-width: 420px;
  min-width: unset;
  display: flex;
  align-items: center;
}


.has-dark .HUD {
  background: #292c3c;
}

.HUD.UI {
  min-width: 180px;
  align-items: unset;
}

.Omnibar {
  padding-bottom: 20px;
}

.HUD:after {
  border: none;
  background: #292c3c;
}

.HUD.D:after {
  background: #292c3c;
}


/* #omni */
/* ^ do not touch this line ^ */

* {
  font-family: "VictorMono Nerd Font" !important;
}

.transparent {
  opacity: 0.96;
}

body {
  border-radius: 16px;
  border: 3px #eebebe solid;
  box-shadow: 2 9px 15px #232634;
}

body.has-dark {
  border-color: #eebebe;
}

body:after {
  border: unset;

}

#bar {
  background: #232634;
  border-radius: unset;
  border-bottom: unset;
  height: 36px;
  padding: 9px 10px;
  padding-bottom: 5px;
}

.has-dark #bar {
  background: #232634;
}

#bar::before {
  content: "❯";
  display: inline-block;
  width: 1rem;
  height: 16px;
  position: absolute;
  left: 1rem;
  z-index: 300;
  font-size: 9;
  padding: 6px 0;
  line-height: 1.6em;
  text-align: right;
  color: #c6d0f5;
  font-weight: bold;
}

.has-dark #bar::before {
  color: #232634;
}

#input {
  border: none;
  background: none;
  box-shadow: unset;
  font-size: ;
  color: #f2d5cf;
  padding-left: 2rem;
}

.has-dark #input {
  color: #f2d5cf;
}

#toolbar {
  top: 7px;
  right: 14px;
}

#toolbar .button {
  height: 23px;
  width: 24px;
  padding: 3px;
  cursor: pointer;
  border: 3px transparent solid;
  position: relative;
  opacity: 0.5;
  transition: 100ms ease-in-out opacity;
}

#toolbar .button:hover {
  background: unset;
  opacity: 1;
}

#toolbar .button > svg {
  opacity: 0.5;
}

#toolbar .button#toggle-dark > svg {
  transform: translateY(1px) rotate(45deg);
}

#toolbar .button#close > svg {
  transform: scale(1.4);
}

#toolbar .button#toggle-dark .i-moon {
  fill: unset;
  stroke-width: 1.4;
}

#toolbar .button#toggle-dark .i-sun {
  stroke-width: 2.1;
}

.has-dark #toolbar .button#toggle-dark .i-moon {
  fill: #ddd8cd;
  stroke: #ddd8cd;
}

.has-dark #toolbar .button#toggle-dark .i-sun {
  fill: #ddd8cd;
  stroke: #ddd8cd;
}

.has-dark #toolbar .button#close > svg {
  fill: #ddd8cd;
  stroke: #ddd8cd;
}

#list {
  background: #292c3c;
  border-radius: unset;
  padding: 5px;
  padding-bottom: 6px;
}

.has-dark #list {
  background: #292c3c;
}

.item {
  padding: 6px 10px;
  padding-top: 3px;
  margin: 0 5px;
  margin-top: -2px;
  border-radius: 6px;
  border: unset;
  border: 3px transparent solid;
  height: 44px;
}

.item::before {
  position: absolute;
  background: none;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  content: "";
  z-index: -1;
}

.item.s,
.item:hover {
  background-color: unset;
  border: 3px #f2d5cf solid;
}

.has-dark .item.s,
.has-dark .item:hover {
  border: 3px #f2d5cf solid;;
}

.item.s::before {
  background-color: rgba(255, 255, 255, 0.836);
}

.item:hover::before {
  background-color: #fff;
}

.has-dark .item.s::before {
  background-color: rgba(80, 83, 84, 0.411);
}

.has-dark .item:hover::before {
  background-color: rgba(80, 83, 84, 0.555);
}

.item .icon {
  width: 24px;
  height: 24px;
  padding-right: unset;
  margin-right: 10px;
  margin-top: 5px;
  background-position: bottom right;
}

.has-dark .item .icon {
  fill: #a5adce;
  stroke: #a5adce;
}

.item .icon path {
  opacity: 0.45;
  position: absolute;
  z-index: -1;
  transform-origin: 0px 0px;
  transform: scale(0.75);
}

.item .top {
  color: #f2d5cf;
  position: relative;
  height: 30px;
}

.has-dark .item .top {
  color: #f2d5cf;
}

.item .top .title {
  font-size: 16;
  line-height: 0.8em;
  margin-top: 2px;
}

.item .top .title match {
  color: #e78284;
}

.has-dark .item .top .title match {
  color: #e78284;
}

.item .top .title:empty::after {
  content: "<blank>";
}

.item .bottom {
  margin-top: -12px;
  padding-left: 14px;
}

.item .bottom a {
  color: #a5adce;
  opacity: 0.9
  font-size: 16;
}

.has-dark .item .bottom a {
  color: #a5adce;
  opacity: 0.9
}

.item .bottom a match {
  color: #ea999c;
}

.has-dark .item .bottom a match {
  color: #ea999c;
}

/* #find */
/* ^ do not touch this line ^ */

* {
  font-family: "VictorMono Nerd Font" !important;
  background: unset;
}

:host,
body {
  background-color: #292c3c !important;
  margin: 0 !important;
  padding: 0 !important;
}

:host(.D),
body.D {
  background-color: #292c3c !important;
  color: #c6d0f5 !important;
}

.r {
  color: #c6d0f5;
  border: none;
  border-radius: unset;
  box-shadow: unset;
  background: #292c3c;
  height: 10px;
}

.r.D {
  background: #292c3c;
  color: #c6d0f5;
}

#i {
  color: #c6d0f5;
}

.D #i {
  color: #c6d0f5;
}
```
