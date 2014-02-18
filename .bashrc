#----------------------------------------------------------
# .bashrc
# Author: Adam Sherwood
# Email: theherk@gmail.com
#----------------------------------------------------------

# Load RVM into a shell session *as a function*
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

PATH=$PATH:$HOME/.rvm/bin:$HOME/.rvm/gems/ruby-1.9.3-p385/bin:$HOME/.rvm/gems/ruby-1.9.3-p385/gems/compass-0.12.2/bin

# User specific environment and startup programs
PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/adt-bundle-linux-x86_64-20131030/sdk/platform-tools:$HOME/.cabal/bin:$HOME/Projects/shell/capture
export PYTHONPATH=/usr/lib/python3.3/site-packages

export PATH

# Powerline for Bash
#----------------------------------------------------------
# if [ -f /usr/lib/python3.3/site-packages/powerline/bindings/bash/powerline.sh ]; then
#     source /usr/lib/python3.3/site-packages/powerline/bindings/bash/powerline.sh
# fi

# Load better Solarized Colors
#----------------------------------------------------------

# eval `dircolors ~/.dir_colors`

# History Control
#----------------------------------------------------------

# don't put duplicate lines in the history.
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# history length
HISTSIZE=1000
HISTFILESIZE=2000

# Color Test
#----------------------------------------------------------

# C1=$(tput setaf 1)
# C2=$(tput setaf 2)
# C3=$(tput setaf 3)
# C4=$(tput setaf 4)
# C5=$(tput setaf 5)
# C6=$(tput setaf 6)
# C7=$(tput setaf 7)
# C8=$(tput setaf 8)
# C9=$(tput setaf 9)
# C10=$(tput setaf 10)
# C11=$(tput setaf 11)
# C12=$(tput setaf 12)
# C13=$(tput setaf 13)
# C14=$(tput setaf 14)
# C15=$(tput setaf 15)
# C16=$(tput setaf 16)
# C17=$(tput setaf 17)
# C18=$(tput setaf 18)
# C19=$(tput setaf 19)
# C20=$(tput setaf 20)
# C21=$(tput setaf 21)
# C22=$(tput setaf 22)
# C23=$(tput setaf 23)
# C24=$(tput setaf 24)
# C25=$(tput setaf 25)
# C26=$(tput setaf 26)
# C27=$(tput setaf 27)
# C28=$(tput setaf 28)
# C29=$(tput setaf 29)
# C30=$(tput setaf 30)
# C31=$(tput setaf 31)
# C32=$(tput setaf 32)
# C33=$(tput setaf 33)
# C34=$(tput setaf 34)
# C35=$(tput setaf 35)
# C36=$(tput setaf 36)
# C37=$(tput setaf 37)
# C38=$(tput setaf 38)
# C39=$(tput setaf 39)
# C40=$(tput setaf 40)

# function customPrompt {
#     PS1='
#     \[$C1\]1
#     \[$C2\]2
#     \[$C3\]3
#     \[$C4\]4
#     \[$C5\]5
#     \[$C6\]6
#     \[$C7\]7
#     \[$C8\]8
#     \[$C9\]9
#     \[$C10\]10
#     \[$C11\]11
#     \[$C12\]12
#     \[$C13\]13
#     \[$C14\]14
#     \[$C15\]15
#     \[$C16\]16
#     \[$C17\]17
#     \[$C18\]18
#     \[$C19\]19
#     \[$C20\]20
#     \[$C21\]21
#     \[$C22\]22
#     \[$C23\]23
#     \[$C24\]24
#     \[$C25\]25
#     \[$C26\]26
#     \[$C27\]27
#     \[$C28\]28
#     \[$C29\]29
#     \[$C30\]30
#     \[$C31\]31
#     \[$C32\]32
#     \[$C33\]33
#     \[$C34\]34
#     \[$C35\]35
#     \[$C36\]36
#     \[$C37\]37
#     \[$C38\]38
#     \[$C39\]39
#     \[$C40\]40
#     \$ \[$RESET\]'
# }

# PROMPT_COMMAND=customPrompt

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

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Aliases and Functions
#----------------------------------------------------------

# Start XFCE
alias x='startxfce4'

# List
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# sudo last command
alias please='sudo $(history -p !!)'

#netinfo - shows network information for your system
netinfo () {
    echo "--------------- Network Information ---------------"
    /sbin/ifconfig | awk /'inet addr/ {print $2}'
    /sbin/ifconfig | awk /'Bcast/ {print $3}'
    /sbin/ifconfig | awk /'inet addr/ {print $4}'
    /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
    myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
    echo "${myip}"
    echo "---------------------------------------------------"
}

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

# clock - A bash clock that can run in your terminal window.
clock (){
    while true;do clear;echo "===========";date +"%r";echo "===========";sleep 1;done
}

# rsync simple SRC then DEST
rsim () {
  rsync -avz -e ssh --progress $1 $2
}

# git pretty logs
alias gitls="git log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)'"
alias gittree="git log --pretty=oneline --decorate --graph"

# git completion
source ~/.git-completion.bash

# git doge
alias wow="git status"
alias many="git"
alias much="git"
alias so="git"
alias such="git"
alias very="git"

# list rvm gems
# alias rvmls="ls `rvm gemdir`/gems"

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

# back to previous location
alias back="cd $OLDPWD"

# package install
alias syi="sudo yum install"
alias sai="sudo apt-get install"
alias spS="sudo pacman -S"

# ssh connections
alias sshcrmcs="ssh adam@162.242.164.180"
alias sshrespond="ssh respond4@responders.us"

# Prettify JSON using Python
prettyjson () {
  cat $1 | python -mjson.tool > $2
}

# Chromium websites
function duck {
    chromium-browser 'https://duckduckgo.com/?q='"$1";
}
export -f duck

function google {
    chromium-browser 'https://google.com/?q='"$1"'&output=search#hl=en&output=search&sclient=psy-ab&q='"$1";
}
export -f google

function wiki {
    chromium-browser 'http://en.wikipedia.org/wiki/'"$1";
}
export -f wiki

alias xkcd="chromium-browser http://www.xkcd.com"
alias reddit="chromium-browser http://reddit.com/"

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
    rsync -auvv /media/BiggerJohn/ /media/adam/theherk_gmailcom/
}

# set editor
export EDITOR=gvim
alias edit='gvim'
