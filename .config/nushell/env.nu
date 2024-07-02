mkdir ~/.cache/starship
mkdir ~/.cache/zoxide
starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.cache/zoxide/init.nu
