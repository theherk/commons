setxkbmap us -variant colemak -option ctrl:nocaps -option caps:ctrl_modifier

dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
xrdb -merge ~/.Xresources

exec i3
#exec gnome-session
