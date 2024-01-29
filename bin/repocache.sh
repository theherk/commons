cat $HOME/commons/.projects-extra | envsubst >$HOME/.projects && fd -HI -d 6 "^\.git\$" $P | xargs dirname 2>/dev/null >>$HOME/.projects

if command -v zoxide >/dev/null; then
	cat $HOME/.projects | xargs zoxide add
else
	echo "zoxide not available; not adding paths"
fi
