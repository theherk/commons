# theherk commons

These are the configuration details and files I use to configure my environment. Feel free to peruse if it suits you.

_update 2021-06-29_: The koolaid is delicious. I have removed most things that were unique to Arch, Manjaro, and Windows. Not that I'll never use them, but probably not often. Nevertheless, if you seek files that were used in that linux context, like X configuration, termite, rofi, i3, etc. check out one of the blockpoints up to b3.

## Features

- [Kaolin Emacs Themes](https://github.com/ogdenwebb/emacs-kaolin-themes) / [Kaolin Inspired Themes](https://github.com/alternateved/kaolin-inspired)
- [Doom Emacs](https://github.com/hlissner/doom-emacs)
- [Bruce Lee](https://en.wikipedia.org/wiki/Bruce_Lee)
- [screenshots below](#screenshots)
- [bat](https://github.com/sharkdp/bat) in lieu of `cat`
- [caddy](https://caddyserver.com/) for running simple servers
- [direnv](https://direnv.net/)
- [dropbox](https://www.dropbox.com/) for syncing org folder
- [exa](https://github.com/ogham/exa) in lieu of `ls`
- [fd](https://github.com/sharkdp/fd) for searching files
- [fzf](https://github.com/junegunn/fzf) for fuzzy finding; mostly command history
- [git-delta](https://github.com/ducaale/xh) as a highlighting pager
- [grip](https://github.com/joeyespo/grip) for rendering markdown
- [helix](https://helix-editor.com/) for simple edits in the shell
- [navi](https://github.com/denisidoro/navi) for command reference
- [podman](https://podman.io/) in lieu of docker desktop
- [pyenv](https://github.com/pyenv/pyenv) for all my python environment needs
- [ripgrep](https://github.com/BurntSushi/ripgrep) for the best in-file search tool out there
- [skim](https://github.com/lotabout/skim) for some fuzzy finding
- [starship](https://starship.rs/) for the best prompt
- [xh](https://github.com/ducaale/xh) for http requests

## Installation

#### Get this repository.

    git clone git@gitlab.com:theherk/commons.git ~
    # git clone https://gitlab.com/theherk/commons.git ~ # in case you aren't me

#### Link everything where to needs to be.

    ~/commons/links.sh

#### Bootstap mac os configuration.

You can't really just run this unattended.

    # ~/commons/macup.sh

But you can follow [the script](macup.sh) as copypasta steps.

## emacs literate configuration

You can find my configuration [here](.config/doom/config.org).

## Screenshots

#### desktop

![desktop](img/desktop.png "desktop")

#### emacs

![emacs-splash](img/emacs-splash.png "emacs-splash")

![emacs-treemacs](img/emacs-treemacs.png "emacs-treemacs")

![emacs-dired](img/emacs-dired.png "emacs-dired")

![emacs-org-zen](img/emacs-org-zen.png "emacs-org-zen")

#### firefox

![firefox-music](img/firefox-music.png "firefox-music")

#### slack

![slack](img/slack.png "slack")

#### wuzterm

![wuzterm-lists](img/wuzterm-lists.png "wuzterm-lists")

![wuzterm-sysinfo](img/wuzterm-sysinfo.png "wuzterm-sysinfo")

## Credits

More are warranted, but the two I can think to mention off the bat are:

- [matlocktheartist](https://www.deviantart.com/matlocktheartist/art/Bruce-Lee-Puzzled-322967405) for providing the awesome Bruce Lee art.

## Enjoy
