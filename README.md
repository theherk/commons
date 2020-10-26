theherk commons
===============

These are the configuration details and files I use to configure my environment. Feel free to peruse if it suits you.

Features
--------

- [Arch](https://www.archlinux.org/); or [Manjaro](https://manjaro.org/)
- [Dracula](https://draculatheme.com/) all the things
- [Spacemacs](http://spacemacs.org/)
- termite
- tmux
- zsh
- slack
- firefox
- i3
- polybar
- rofi
- Bruce Lee
- [screenshots below](#screenshots)

I'm sure I'm missing some information, but the configuration should have everything required.

Installation
------------

#### Get this repository. ####

    git clone git@gitlab.com:theherk/commons.git ~
    # or ...
    git clone https://gitlab.com/theherk/commons.git ~

#### Install packages, yay (AUR helper), and AUR packages. ####

    sudo pacman -S --noconfirm - < ~/commons/pkgs
    cd $(mktemp -d)
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    yay -S --noconfirm - < ~/commons/pkgs-aur

#### Install spacemacs and neobundle. ####

    rm -rf ~/.emacs.d && git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

#### Link everything where to needs to be. ####

    ~/commons/links.sh

#### Link spaceship prompt. ####

    sudo ln -s /usr/lib/spaceship-prompt/spaceship.zsh-theme /usr/share/oh-my-zsh/custom/themes/spaceship.zsh-theme

Firefox is bad about gtk dark themes causing form fields to be unreadable. Easy fix found [here](https://bugzilla.mozilla.org/show_bug.cgi?id=1283086#c23); add key `widget.content.gtk-theme-override`, and set the string to `Adwaita:light`.

Screenshots
-----------

#### rofi ####

![rofi](https://s3-us-west-2.amazonaws.com/theherk-pub/commons-screenshots/rofi.png "rofi")

#### emacs ####

![emacs](https://s3-us-west-2.amazonaws.com/theherk-pub/commons-screenshots/emacs.png "emacs")

#### tmux ####

![tmux](https://s3-us-west-2.amazonaws.com/theherk-pub/commons-screenshots/tmux.png "tmux")

#### browse ####

![browse](https://s3-us-west-2.amazonaws.com/theherk-pub/commons-screenshots/browse.png "browse")

Windows
-------

If stuck using a Windows environment, I use the following in my WSL 2 environment.

[VcXsrv](https://sourceforge.net/projects/vcxsrv/) is the X-service to run applications natively in Windows.

Here is a snippet I tag onto my .zprofile:

```
# WSL stuff

export DISPLAY=$(ip route | awk '{print $3; exit}'):0
export LIBGL_ALWAYS_INDIRECT=1
export GDK_SCALE=2

export WINHOME=/mnt/c/Users/h4s
export WINP=$WINHOME/projects
```

Credits
-------

More are warranted, but the two I can think to mention off the bat are:

- [matlocktheartist](https://www.deviantart.com/matlocktheartist/art/Bruce-Lee-Puzzled-322967405) for providing the awesome Bruce Lee art.
- [Zeno Rocha](https://zenorocha.com/) for creating the [Dracula Theme](https://draculatheme.com/).

### Dracula Colors ###

| Palette    | Hex     | RGB           | x256                       |
|------------|---------|---------------|----------------------------|
| Background | #282a36 | 40, 42, 54    | 17 (236 looks much better) |
| Current    | #44475a | 68, 71, 90    | 59                         |
| Foreground | #f8f8f2 | 248, 248, 242 | 231                        |
| Comment    | #6272a4 | 98, 114, 164  | 61                         |
| Cyan       | #8be9fd | 139, 233, 253 | 117                        |
| Green      | #50fa7b | 80, 250, 123  | 84                         |
| Orange     | #ffb86c | 255, 184, 108 | 215                        |
| Pink       | #ff79c6 | 255, 121, 198 | 212                        |
| Purple     | #bd93f9 | 189, 147, 249 | 141                        |
| Red        | #ff5555 | 255, 85, 85   | 203                        |
| Yellow     | #f1fa8c | 241, 250, 140 | 228                        |

Enjoy
---
