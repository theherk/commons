HISTCONTROL=ignoredups:ignorespace # don't put duplicate lines in the history.
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=1000
HISTFILESIZE=2000

BASE03=$(tput setaf 234)
BASE02=$(tput setaf 235)
BASE01=$(tput setaf 240)
BASE00=$(tput setaf 241)
BASE0=$(tput setaf 244)
BASE1=$(tput setaf 245)
BASE2=$(tput setaf 254)
BASE3=$(tput setaf 230)
YELLOW=$(tput setaf 136)
ORANGE=$(tput setaf 166)
RED=$(tput setaf 160)
MAGENTA=$(tput setaf 125)
VIOLET=$(tput setaf 61)
BLUE=$(tput setaf 33)
CYAN=$(tput setaf 37)
GREEN=$(tput setaf 64)
BOLD=$(tput bold)
RESET=$(tput sgr0)
function customPrompt {
    BRANCH=""
        if git branch 2>/dev/null 1>/dev/null; then\
            BRANCH="$(git branch 2>/dev/null | grep \* |  cut -d " " -f 2)";\
        fi;
    if [ "$BRANCH" != "" ]; then\
        BRANCH="($BRANCH) ";\
    fi;
    VENV=${VIRTUAL_ENV##*/}
    if [ "$VENV" != "" ]; then\
        VENV="[$VENV] ";\
    fi;
    PS1='\[$BOLD\]\[$GREEN\]\u@\h \[$YELLOW\]$VENV\[$ORANGE\]$BRANCH\[$CYAN\]\W \[$CYAN\]\$ \[$RESET\]'
}
PROMPT_COMMAND=customPrompt

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ls='ls -lF --color=auto'
alias ll='ls -AlF --color=auto'

source ~/.git-completion.bash
