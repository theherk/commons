#----------------------------------------------------------
# Author: Adam Sherwood
# Email: theherk@gmail.com
#----------------------------------------------------------

export ARCHFLAGS="-arch x86_64"

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd interactivecomments
unsetopt beep
zstyle :compinstall filename '/home/h4s/.zshrc'
autoload -Uz compinit
compinit

ZSH=/usr/share/oh-my-zsh/
# ZSH=$HOME/.oh-my-zsh/
plugins=(archlinux aws bower git golang pip python sudo systemd)
DISABLE_AUTO_UPDATE="true"
ZSH_THEME="spaceship"
SPACESHIP_CHAR_SYMBOL="➜  "
# SPACESHIP_GIT_SYMBOL="📎"
SPACESHIP_BATTERY_SHOW="false"

if [[ $TERM == "dumb" ]]; then # in emacs
    PS1='%(?..[%?])%!:%~%# '
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
else
    source $ZSH/oh-my-zsh.sh
fi

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='emacsclient'
fi

bindkey '^r' history-incremental-search-backward
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias awsu='unset AWS_PROFILE'
alias cfmt='cargo +nightly fmt'
alias cclip='cargo +nightly clippy'
alias cm='sudo loadkeys colemak'
alias conv='convert_to_crf20.sh'
alias ed='emacs --daemon'
alias ec='emacsclient'
alias ecf='emacsclient -c&'
alias ect='emacsclient -t'
alias fr='find . -iname "*.rar"'
alias fz='find . -iname "*.7z"'
alias gls="git log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)'"
alias grep='grep --color'
alias gsuperpush="git push --force --tags origin 'refs/heads/*'"
alias gt='gogtags -v'
alias gtree="git log --pretty=oneline --decorate --graph"
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
alias jackmod='sudo pactl load-module module-jack-sink'
alias l='ls -lh'
alias ll='ls -AlFh'
alias llt='ls -AlFtrh'
# alias ls='ls --color=auto'
alias lv="ls $VENVS"
alias mvni='mvn clean install -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true'
alias mvnp='mvn clean package -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true'
alias packern='packer --noedit --noconfirm'
alias pacls='sudo pacman -Qqen'
# alias puml='java -jar $HOME/bin/plantuml.jar'
alias puml='plantuml'
alias py='python'
alias r="rsync -rltvz -e ssh --progress"
alias restart="sudo shutdown -r now"
alias rm="rm -iv"
alias sc='screencap.sh'
alias shutdown="sudo shutdown -h now"
alias startx='ssh-agent startx'
alias t='tree'
alias t1='tree -L 1'
alias t2='tree -L 2'
alias t3='tree -L 3'
alias t4='tree -L 4'
alias t5='tree -L 5'
alias tree='tree -C'
alias tmpd='cd $(mktemp -d)'
alias tms="\
    tmux new-session -s 'Main' -n 'Main' -d; \
    tmux new-window -n 'Vim'; \
    tmux send-keys -t 'Vim' vs ENTER; \
    tmux select-window -t Main; \
    tmux attach -t Main"
alias trash="rm -rf ~/.local/share/Trash/"
alias up="underscore pretty"
alias vs="vim --servername MainVim"
alias wow="git status"
alias xc='xclip -sel clip'
alias xkcd='echo "xkcdpass --count=5 --acrostic='\''flow'\'' --min=4 --max=6 --valid_chars='\''[a-z]'\''"'

awsp () {
    export AWS_PROFILE=${1}
}
dirsize () {
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
        egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm -rf /tmp/list
}
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1 ;;
            *.tar.gz)    tar xzf $1 ;;
            *.bz2)       bunzip2 $1 ;;
            *.rar)       unrar e $1 ;;
            *.gz)        gunzip $1 ;;
            *.tar)       tar xf $1 ;;
            *.tbz2)      tar xjf $1 ;;
            *.tgz)       tar xzf $1 ;;
            *.zip)       unzip $1 ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z e $1 ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
jsonesc () {
    python -c 'import json,sys; print(json.dumps('$1'))'
}
prettyjson () {
    cat $1 | python -mjson.tool > $2
}
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
venv2 () {
    virtualenv -p /usr/bin/python2 $VENVS/${1}
    venvact ${1}
    pip install ipython
}
venv3 () {
    python3 -m venv $VENVS/${1}
    venvact ${1}
    pip install ipython
}
venvact () {
    source ${VENVS}/${1}/bin/activate
}
vse () {
    vim --servername MainVim --remote $1
    tmux select-window -t 'Vim'
}
vst () {
    vim --servername MainVim --remote-tab $1
    tmux select-window -t 'Vim'
}

# sometimes home doesn't work. fix from here: https://wiki.archlinux.org/index.php/Zsh#Key_bindings
unsetopt MULTIBYTE

autoload zkbd
# don't forget to run zkbd
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
