HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
unsetopt beep
zstyle :compinstall filename '/home/h4s/.zshrc'
autoload -Uz compinit && compinit

ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"
plugins=(
    aws
    brew
    fzf
    golang
    ripgrep
    rust
    terraform
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)

export EDITOR='hx'
export PAGER="less -FRSX"

# Good autosuggest color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=6"

alias awsl='aws sso login --profile $AWS_PROFILE'
alias awsr="aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'"
alias awsu='unset AWS_PROFILE'
alias dumplynx='lynx -dump -stdin'
alias dumpw3m='w3m -dump -T text/html'
alias ef='emacsclient -c -n -e "(make-frame)"'
alias es='brew services restart emacs-plus'
alias er='unrar e'
alias ez='7z e'
alias fr='find . -iname "*.rar"'
alias fz='find . -iname "*.7z"'
alias hxr='hx $(sk --ansi -i -c '\''rg --color=always --hidden --line-number "{}"'\'' | cut -d: -f1-2)'
alias gl='gproxy-auto.sh'
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
alias l='exa -l --icons'
alias lg='lazygit'
alias ll='exa -alF --icons'
alias ls='exa'
alias lt='exa -T --icons'
alias r="rsync -rltvz -e ssh --progress"
alias tfn='tee >(awk '"'"'match($0, /# (\S+\.(\[.+\]|\S+)+)/, g) { m=g[1] } match($0, /^(.* )resource .*{$/, g) { print g[1] m }'"'"' | sort)'
alias tfpp='tfp | tee plan'
alias tft='TF_LOG=trace TF_LOG_PATH=tf-trace-$(date +%FT%T+01).log'
alias tfw='rg --color never "will be|must be" | rg -v "will be read" | sed "s/ be /|/g" | sort -t "|" -k2 | awk '"'"'BEGIN{FS="|"}{o=$NF!=a&&a?"\n"$2"\n"$1:!a?$2"\n"$1:$1;a=$NF;print o}'"'"' | sed -E "s/ will| must//" | sed "s/# //"'
alias tn="trans en:no -b "
alias te="trans no:en -b "
alias tmpd='cd $(mktemp -d)'
alias up="underscore pretty"
alias util-list="aws ec2 describe-instances --filters 'Name=tag:Name,Values=*util' --output text --query 'Reservations[*].Instances[*].InstanceId'"
alias util-list-buildhost="aws ec2 describe-instances --filters 'Name=tag:Name,Values=*buildhost' --output text --query 'Reservations[*].Instances[*].InstanceId'"
alias wow="git status"
alias xc='xclip -sel clip'
alias xp='cat p|xc'

awsp () {
    if [ -z "$1" ]; then
        echo $AWS_PROFILE
    else
        export AWS_PROFILE=${1}
    fi
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
gfixtags () {
    for t in $(gvtags); do gtr $t ${t#v}; done
    for t in $(gvtags); do git tag -d $t; done
}
gtr () {
    SOURCE_TAG=${1} NEW_TAG=${2}; deref() { git for-each-ref "refs/tags/$SOURCE_TAG" --format="%($1)" ; }; GIT_COMMITTER_NAME="$(deref taggername)" GIT_COMMITTER_EMAIL="$(deref taggeremail)" GIT_COMMITTER_DATE="$(deref taggerdate)" git tag "$NEW_TAG" "$(deref "*objectname")" -a -sm "$(deref contents:subject)"

    # If any of the tags have bodies, this will add the contents.
    # SOURCE_TAG=${1} NEW_TAG=${2}; deref() { git for-each-ref "refs/tags/$SOURCE_TAG" --format="%($1)" ; }; GIT_COMMITTER_NAME="$(deref taggername)" GIT_COMMITTER_EMAIL="$(deref taggeremail)" GIT_COMMITTER_DATE="$(deref taggerdate)" git tag "$NEW_TAG" "$(deref "*objectname")" -a -sm "$(deref contents:subject)\n\n$(deref contents:body)"
}
gvtags () {
    for t in $(git tag); do
        if [[ $t =~ ^v ]]; then
            echo $t
        fi;
    done
}
jsonesc () {
    python -c 'import json,sys; print(json.dumps('$1'))'
}
prettyjson () {
    cat $1 | python -mjson.tool > $2
}
sc() {
    if [ ! -n "$NEXUS_USER" ]; then
        export NEXUS_USER="unset"
    fi
    if [ ! -n "$NEXUS_PWD" ]; then
        export NEXUS_PWD="unset"
    fi
    cmd="sceptre ${@#config/}"
    echo $cmd
    eval $cmd
}
util-start() {
    aws ec2 start-instances --instance-ids $1
}
util-connect() {
    aws ssm start-session --target $1
}
venv2 () {
    virtualenv -p /usr/bin/python2 .venv
    venvact .venv
    pip install ipython
}
venv3 () {
    python3 -m venv .venv
    venvact .venv
    pip install ipython
}
venvact () {
    source .venv/bin/activate
}

eval "$(shadowenv init zsh)"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
