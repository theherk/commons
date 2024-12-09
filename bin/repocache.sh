cat $HOME/commons/.projects-extra | envsubst >$HOME/.projects && fd -HI -d 7 "^\.git\$" $P | xargs dirname 2>/dev/null >>$HOME/.projects

if command -v zoxide >/dev/null; then
	cat $HOME/.projects | xargs -I {} zoxide add "{}"
else
	echo "zoxide not available; not adding paths"
fi
