PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/adt-bundle-linux-x86_64-20131030/sdk/platform-tools:$HOME/.cabal/bin:$HOME/Projects/shell/capture
export PYTHONPATH=/usr/lib/python3.3/site-packages
export PATH

# History Control
#----------------------------------------------------------

# don't put duplicate lines in the history.
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# history length
HISTSIZE=1000
HISTFILESIZE=2000

# Prompt Settings
#----------------------------------------------------------

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

# Aliases and Functions
#----------------------------------------------------------

# List
alias ls='ls -lF --color=auto'
alias ll='ls -AlF --color=auto'

#extract - extract many file types
extract () {
    if [ -f $1 ] ; then
    case $1 in
        *.tar.bz2)   tar xjf $1        ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1       ;;
        *.rar)       rar x $1     ;;
        *.gz)        gunzip $1     ;;
        *.tar)       tar xf $1        ;;
        *.tbz2)      tar xjf $1      ;;
        *.tgz)       tar xzf $1       ;;
        *.zip)       unzip $1     ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1    ;;
        *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

#dirsize - report size of given directory
dirsize () {
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
    egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm -rf /tmp/list
}

# rsync simple SRC then DEST
rsim () {
  rsync -avz -e ssh --progress $1 $2
}

# git pretty logs
alias gls="git log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)'"
alias gtree="git log --pretty=oneline --decorate --graph"

# git completion
source ~/.git-completion.bash

# git doge
alias wow="git status"
alias many="git"
alias much="git"
alias so="git"
alias such="git"
alias very="git"

# dot shortcuts
alias home="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# verbose and interactive removal
alias rm="rm -iv"

# empty the trash
alias trash="rm -rf ~/.local/share/Trash/"

# shutdown and restart
alias shutdown="sudo shutdown -h now"
alias restart="sudo shutdown -r now"

# Prettify JSON using Python
prettyjson () {
  cat $1 | python -mjson.tool > $2
}

# sudo for aliases
alias sudo='sudo '

# correct Virtualbox jumping
alias fix='xinput set-prop "VirtualBox mouse integration" "Coordinate Transformation Matrix" 0.5 0 0 0 0.5 0 0 0 1.0;xinput set-prop "VirtualBox mouse integration" "Coordinate Transformation Matrix" 1.0 0 0 0 1.0 0 0 0 1.0'

# mount Virtualbox shared folders
# usage:
# sudo msf <shared folder name> <local folder>
alias msf='mount -t vboxsf'
# unmount Virtualbox shared folders
# usage:
# sudo usf <shared folder name>
alias usf='umount -t vboxsf'

# mint-dev mount drives
mmm () {
    if [ "$(ls -A ~/share/X_DEV/)" ]; then
        # Not Empty / Mounted
        # Unmount
        sudo usf X_DEV
        sudo usf Y_RTC
    elif [ "$(ls -A ~/share/Y_RTC/)" ]; then
        # Not Empty / Mounted
        # Unmount
        sudo usf X_DEV
        sudo usf Y_RTC
    else
        # Empty / Unmounted
        # Mount
        sudo msf X_DEV ~/share/X_DEV/
        sudo msf Y_RTC ~/share/Y_RTC/
    fi
}

thbu () {
    rsync -auvv ~/Projects/ /media/BiggerJohn/Projects/
    rsync -auvv ~/Apps/ /media/BiggerJohn/Apps/
    if [ "$(ls -A /media/adam/SAMWISE/)" ]; then
        # Not Empty / Mounted
        rsync -auvv /media/adam/SAMWISE /media/BiggerJohn/cruzer_backup/
    fi
    if [ "$(ls -A /media/adam/theherk_gmailcom/)" ]; then
        # Not Empty / Mounted
        rsync -auvv /media/BiggerJohn/ /media/adam/theherk_gmailcom/
    fi
}

# set editor
export EDITOR=gvim
alias edit='gvim'


# added by travis gem
[ -f /home/h4s/.travis/travis.sh ] && source /home/h4s/.travis/travis.sh
