function awsp # Set AWS_PROFILE
    argparse --max-args 1 -- $argv
    or return
    switch (count $argv)
        case 1
            set -g -x AWS_PROFILE $argv[1]
        case '*'
            echo $AWS_PROFILE
    end
end

function awspd # Set latest cached creds as default
    set CLI ~/.aws/cli/cache
    set SSO ~/.aws/sso/cache
    aws sts get-caller-identity
    aws configure set aws_access_key_id (bat $CLI/(eza -U $CLI | tail -1) | jq -r .Credentials.AccessKeyId) &&
        aws configure set aws_secret_access_key (bat $CLI/(eza -U $CLI | tail -1) | jq -r .Credentials.SecretAccessKey) &&
        aws configure set aws_session_token (bat $CLI/(eza -U $CLI | tail -1) | jq -r .Credentials.SessionToken) &&
        aws configure set region (bat $SSO/(eza -U $SSO | tail -2 | head -1) | jq -r .region)
end

function fester-deployments # List fester deployments in configuration.
    argparse --min-args 1 --max-args 2 -- $argv
    switch (count $argv)
        case 1
            yq '.[][] |= (map(pick(["region"])))' $argv[1]
        case 2
            yq '.[][] |= (map(pick(["region"]) | select(.[] == "'"$argv[2]"'")))' $argv[1]
    end
end

function last_history_item
    echo $history[1]
end

function _tf_abbr
    set -l prog (set -q TF_PROG && echo $TF_PROG || echo terraform)
    switch $argv[1]
        case tf
            echo $prog
        case tfa
            echo "$prog apply"
        case tfd
            echo "$prog destroy"
        case tfi
            echo "$prog init"
        case tfiu
            echo "$prog init --upgrade"
        case tfp
            echo "$prog plan -lock=false"
        case tfpp
            echo "$prog plan -lock=false | tee _plan"
    end
end

function p # Switch to git project directory from .projects. See alias repocache.
    argparse c/clip -- $argv
    set REPO "$(zoxide query -l | rg --color=never -FxNf ~/.projects | sed s:"$HOME":~: | fzf --reverse)"
    if test -n "$REPO"
        set -l dir (string replace '~' $HOME $REPO)
        if set -q _flag_clip
            echo -n $dir | pbcopy
            echo "Copied: $dir"
        else
            z $dir
        end
    end
end

function pwa # add password to keyring
    argparse --min-args 2 --max-args 2 -- $argv
    security add-generic-password -s $argv[1] -a $argv[2] -w
end

function pwdel # delete password in keyring
    argparse --min-args 2 --max-args 2 -- $argv
    security delete-generic-password -s $argv[1] -a $argv[2]
end

function pwf # find password in keyring
    argparse --min-args 2 --max-args 2 -- $argv
    security find-generic-password -w -s $argv[1] -a $argv[2]
end

function rghist # search history
    history | rg $argv
end

function ssmp # get ssm parameter value
    aws ssm get-parameter --name $argv | jq -r .Parameter.Value
end

function ssmpd # get ssm parameter value with decryption
    aws ssm get-parameter --with-decryption --name $argv | jq -r .Parameter.Value
end

function t # tree with depth
    argparse --name tree --min-args 0 --max-args 2 -- $argv
    if test (count $argv) -lt 1
        eza -T
    else
        eza -T -L $argv
    end
end

function util-connect # connect to util bastion
    argparse --min-args 1 --max-args 1 -- $argv
    aws ssm start-session --target $argv
end

function util-start # start util bastion
    argparse --min-args 1 --max-args 1 -- $argv
    aws ec2 start-instances --instance-ids $argv
end

function util-stop # stop util bastion
    argparse --min-args 1 --max-args 1 -- $argv
    aws ec2 stop-instances --instance-ids $argv
end

function _notify_tf_done --on-event fish_postexec
    test $CMD_DURATION -gt 5000; or return
    string match -qr '^(terraform|tofu)\b' -- $argv[1]; or return
    set -q ZELLIJ_SESSION_NAME; or return
    for session in (zellij list-sessions -ns 2>/dev/null | string split \n)
        zellij --session $session pipe -- "zjstatus::notify:: tf done" &>/dev/null
    end
end

function venv3
    python3 -m venv .venv
    venvact .venv
    pip install ipython
end

function venvact
    source .venv/bin/activate
end
