TheHerk dotfiles
================

Installation
------------

    git clone git@gitlab.com:theherk/commons.git ~
    ~/commons/links.sh
    < ~/commons/pkgs xargs -I{} -d'\n' sudo pacman -S {}
    < ~/commons/pkgs-aur xargs -I{} -d'\n' yaourt pacman -S {}
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh # yeah... don't be dumb

Firefox is bad about gtk dark themes causing form fields to be unreadable. Easy fix found [here](https://bugzilla.mozilla.org/show_bug.cgi?id=1283086#c23); add key `widget.content.gtk-theme-override`, and set the string to `Adwaita:light`.

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
