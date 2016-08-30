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
setopt appendhistory autocd interactivecomments
unsetopt beep
#bindkey -v
zstyle :compinstall filename '/home/adam/.zshrc'
autoload -Uz compinit
compinit

# oh-my-zsh
# ---------

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# theme
ZSH_THEME="mortalscumbag"

# for solarized
#eval `dircolors /usr/src/dircolors/dircolors-solarized/dircolors.256dark`
alias grep='grep --color'

# disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# plugins
plugins=(bower git npm nyan pip python systemd)

source $ZSH/oh-my-zsh.sh

# User configuration

export GOPATH=$HOME/projects/go/
export PATH=/usr/local/bin:$HOME/bin:$GOPATH/bin/:$HOME/.gem/ruby/2.2.0/bin:$HOME/.cabal/bin/:$PATH

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

# backsearching
bindkey '^r' history-incremental-search-backward
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# get typing
alias cm='sudo loadkeys colemak'

# python
alias py='python'

# call ipython in virtualenv
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"

# list
alias l='ls -l --color=auto'
alias ls='ls --color=auto'
alias ll='ls -AlF --color=auto'
alias llt='ls -AlFtr --color=auto'

# xclip
alias xc='xclip -sel clip'

# source vimx on machines that need +xcopy_clipboard
if [ -e /usr/bin/vimx ]; then alias vim='/usr/bin/vimx'; fi

# vim server
alias vs="vim --servername MainVim"
vse () {
    vim --servername MainVim --remote $1
    tmux select-window -t 'Vim'
}
vst () {
    vim --servername MainVim --remote-tab $1
    tmux select-window -t 'Vim'
}

# venv create and activate $VENVS
export VENVS=~/.venvs/
venvnew () {
    pyvenv ${VENVS}${1}
    venvact ${1}
}
venvact () {
    source ${VENVS}${1}/bin/activate
}
alias lv="ls $VENVS"

# curl with pretty js output
curljs () {
    curl -s ${1} | underscore pretty --color
}

# tmux
alias tms="\
    tmux new-session -s 'Main' -n 'Main' -d; \
    tmux new-window -n 'Vim'; \
    tmux send-keys -t 'Vim' vs ENTER; \
    tmux select-window -t Main; \
    tmux attach -t Main"

# git remote update
alias new-remote='git remote set-url origin "git@gitlab.eng.cleardata.com:$(git remote -v | grep origin | head -1 | awk '"'"'{print $2}'"'"' | cut -d ":" -f 2)"'

# mvn shortcuts
alias mvni='mvn clean install -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true'
alias mvnp='mvn clean package -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true'

# pacman - list installed packages
alias pacls='sudo pacman -Qqen'

# arch wiki
alias wiki='google-chrome-stable /usr/share/doc/arch-wiki/html/en/Main_page.html; echo "You could also use wiki-search or wiki-search-lite."'

# generate - password; requires pip install xkcdpass
alias xp='echo "xkcdpass --count=5 --acrostic='\''flow'\'' --min=4 --max=6 --valid_chars='\''[a-z]'\''"'

# screencap
alias sc='screencap.sh'
alias conv='convert_to_crf20.sh'

# load JACK module
alias jackmod='sudo pactl load-module module-jack-sink'

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

# startx with ssh-agent
alias startx='ssh-agent startx'

# rsync simple SRC then DEST
#rsim () {
  #rsync -rltvz -e ssh --progress $1 $2
#}
alias r="rsync -rltvz -e ssh --progress"

# git pretty logs
alias gls="git log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)'"
alias gtree="git log --pretty=oneline --decorate --graph"

# git that requires shell
git_rm_submodule () {
    git submodule deinit $1
    git rm $1
    rm -rf .git/modules/$1
    echo "Submodule $1 removed"
}

# git super push
alias gitsuperpush="git push --force --tags origin 'refs/heads/*'"
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
#archey

#export LD_PRELOAD=~/bin/libhostspriv.so

# sometimes home doesn't work. fix from here: https://wiki.archlinux.org/index.php/Zsh#Key_bindings
unsetopt MULTIBYTE

autoload zkbd
# don't forget to run zkbd
# source ~/.zkbd/$TERM-:0 # may be different - check where zkbd saved the configuration:
source ~/.zkbd/$TERM* # may be different - check where zkbd saved the configuration:

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

# added by travis gem
#[ -f /home/h4s/.travis/travis.sh ] && source /home/h4s/.travis/travis.sh
