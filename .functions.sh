awsp () {
    if [ -z "$1" ]; then
        echo $AWS_PROFILE
    else
        export AWS_PROFILE=${1}
    fi
}

baseurl() { # Get base url from full url. scheme://domain
    scheme=${1%%://*}
    without_scheme=${1##"$scheme"://}
    echo "$scheme://${without_scheme%%/*}"
}

colordump () { # Dump primary term colors.
  for c in {0..15}; do
    printf "\033[48;5;%sm%3d\033[0m " "$c" "$c"
    if (( c == 15 )) || (( c > 15 )) && (( (c-15) % 6 == 0 )); then
      printf "\n";
    fi
  done
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

gitp() { # Switch to git project directory from .projects. See alias repocache.
  REPO="$(cat "$HOME"/.projects | sed s:"$HOME":~: | fzf --reverse)"
  [ "$REPO" = "" ] || cd "${REPO/\~/$HOME}" || return
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

pwa () { # add password to keyring
    security add-generic-password -s $1 -a $2 -w
}

pwf () { # find password in keyring
    security find-generic-password -w -s $1 -a $2
}

rgh () { # search history
    history | rg $1
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

ssmp() { # get ssm parameter value
    aws ssm get-parameter --name $1 | jq -r .Parameter.Value
}

ssmpd() { # get ssm parameter value with decryption
    aws ssm get-parameter --with-decryption --name $1 | jq -r .Parameter.Value
}

t() { # tree with depth
    exa -T -L $1
}

util-connect() {
    aws ssm start-session --target $1
}

util-start() {
    aws ec2 start-instances --instance-ids $1
}

util-stop() {
    aws ec2 stop-instances --instance-ids $1
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
