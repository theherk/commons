#----------------------------------------------------------
# .zshrc
# Author: Adam Sherwood
# Email: theherk@gmail.com
#
# note - This requires oh-my-zsh. oh-my-zsh-git in AUR
#
#----------------------------------------------------------

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
unsetopt beep
bindkey -v
zstyle :compinstall filename '/home/adam/.zshrc'
autoload -Uz compinit
compinit

# oh-my-zsh
# ---------

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# theme
ZSH_THEME="gentoo"

# for solarized
eval `dircolors /usr/src/dircolors/dircolors-solarized/dircolors.256dark`
alias grep='grep --color'

# disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# plugins
plugins=(archlinux bower git npm nyan pip python systemd)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=/home/adam/.gem/ruby/2.1.0/bin:$HOME/bin:/usr/local/bin:$PATH

export LANG=en_US.UTF-8

# editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
   export EDITOR='gvim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Aliases and Functions
# ---------------------

# get typing
alias cm='sudo loadkeys colemak'

# list
alias ls='ls --color=auto'
alias ll='ls -AlF --color=auto'

# pacman - list installed packages
alias pacls='sudo pacman -Qqen'

# screencap
alias sc='screencap.sh'
alias conv='convert_to_crf20.sh'

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

# dirsize - report size of given directory
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

# git doge - was hilarious for a minute
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

# prettify JSON using Python
prettyjson () {
  cat $1 | python -mjson.tool > $2
}

# custom backup routine
thbu () {
    # backup home to BiggerJohn
    rsync -auvv ~/apps/ /media/BiggerJohn/home_BACKUP_ONLY/apps/
    rsync -auvv ~/bin/ /media/BiggerJohn/home_BACKUP_ONLY/bin/
    rsync -auvv ~/Desktop/ /media/BiggerJohn/home_BACKUP_ONLY/Desktop/
    rsync -auvv ~/Documents/ /media/BiggerJohn/home_BACKUP_ONLY/Documents/
    rsync -auvv ~/dotfiles/ /media/BiggerJohn/home_BACKUP_ONLY/dotfiles/
    rsync -auvv ~/Dropbox/ /media/BiggerJohn/home_BACKUP_ONLY/Dropbox/
    rsync -auvv ~/Lightworks/ /media/BiggerJohn/home_BACKUP_ONLY/Lightworks/
    rsync -auvv ~/projects/ /media/BiggerJohn/home_BACKUP_ONLY/projects/
    rsync -auvv ~/todo.mkdown /media/BiggerJohn/home_BACKUP_ONLY/todo.mkdown

    # backup BiggerJohn to theherk_gmailcom
    if [ "$(ls -A /run/media/adam/theherk_gmailcom/)" ]; then
        # Not Empty / Mounted
        rsync -auvv /media/BiggerJohn/ /run/media/adam/theherk_gmailcom/
    fi
}

# Run archey in interactive terminals
archey

