if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.functions ]; then
    . ~/.functions
fi

eval "$(starship init bash)"
