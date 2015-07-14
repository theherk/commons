setxkbmap us -variant colemak -option ctrl:nocaps -option caps:ctrl_modifier

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

exec i3

