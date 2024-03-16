if [ -f ~/.aliases.sh ]; then
    . ~/.aliases.sh
fi

if [ -f ~/.dirs ]; then
    . ~/.dirs
fi

if [ -f ~/.functions.sh ]; then
    . ~/.functions.sh
fi

eval "$(starship init bash)"
eval "$(zoxide init bash)"
