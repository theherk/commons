envsubst <$HOME/commons/.projects-extra >$HOME/.projects
fd -HI -d 4 "^\.git\$" $P --exclude gitlab.tech.dnb.no | xargs dirname 2>/dev/null >>$HOME/.projects
fd -HI -d 7 "^\.git\$" $P/gitlab.tech.dnb.no | xargs dirname 2>/dev/null >>$HOME/.projects

if command -v zoxide >/dev/null; then
	tr '\n' '\0' <$HOME/.projects | xargs -0 zoxide add
else
	echo "zoxide not available; not adding paths"
fi
