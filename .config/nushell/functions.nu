# Set or display AWS_PROFILE
def --env awsp [profile?: string] {
    if ($profile | is-empty) {
        if 'AWS_PROFILE' in $env {
            echo $env.AWS_PROFILE
        } else {
            echo "AWS_PROFILE not set"
        }
    } else {
        $env.AWS_PROFILE = $profile
    }
}

# Unset AWS_PROFILE
def awsu [] {
    hide-env AWS_PROFILE
}

# Set latest cached creds as default
def awspd [] {
    let CLI = $"($env.HOME)/.aws/cli/cache"
    let SSO = $"($env.HOME)/.aws/sso/cache"

    aws sts get-caller-identity

    let latest_cli = (ls $CLI | sort-by modified | last | get name)
    let latest_sso = (ls $SSO | sort-by modified | reverse | get name | get 1)

    let creds = (open $latest_cli | from json)
    let region_info = (open $latest_sso | from json)

    aws configure set aws_access_key_id ($creds.Credentials.AccessKeyId)
    aws configure set aws_secret_access_key ($creds.Credentials.SecretAccessKey)
    aws configure set aws_session_token ($creds.Credentials.SessionToken)
    aws configure set region ($region_info.region)
}

# List fester deployments in configuration
def fester-deployments [config_file: path, region?: string] {
    if ($region | is-empty) {
        yq '.[][] |= (map(pick(["region"])))' $config_file
    } else {
        let query = $'.[][] |= (map(pick(["region"]) | select(.[] == "($region)")))'
        yq $query $config_file
    }
}

# Switch to git project directory from .projects using fzf and zoxide
def --env p [] {
    let repo = (zoxide query -l | rg --color=never -FxNf $"($env.HOME)/.projects" | sed $"s:($env.HOME):~:" | fzf --reverse)
    if not ($repo | is-empty) {
        let full_path = ($repo | str replace '~' $env.HOME)
        z $full_path
    }
}

# Add password to macOS keyring
def pwa [service: string, account: string] {
    security add-generic-password -s $service -a $account -w
}

# Delete password from macOS keyring
def pwdel [service: string, account: string] {
    security delete-generic-password -s $service -a $account
}

# Find password in macOS keyring
def pwf [service: string, account: string] {
    security find-generic-password -w -s $service -a $account
}

# Search command history
def rgh [...query: string] {
    history | where command =~ ($query | str join " ")
}

# Get SSM parameter value
def ssmp [name: string] {
    aws ssm get-parameter --name $name | from json | get Parameter.Value
}

# Get SSM parameter value with decryption
def ssmpd [name: string] {
    aws ssm get-parameter --with-decryption --name $name | from json | get Parameter.Value
}

# Tree with optional depth
def t [depth?: int] {
    if ($depth | is-empty) {
        eza -T
    } else {
        eza -T -L $depth
    }
}

# Connect to util bastion via SSM
def util-connect [instance_id: string] {
    aws ssm start-session --target $instance_id
}

# Start util bastion instance
def util-start [instance_id: string] {
    aws ec2 start-instances --instance-ids $instance_id
}

# Stop util bastion instance
def util-stop [instance_id: string] {
    aws ec2 stop-instances --instance-ids $instance_id
}

# Zellij project launcher
def zp [] {
    zellij-project.fish
}

# GitHub Enterprise wrapper
def ghe [...args: string] {
    gh ...$args --hostname $env.GH_HOST
}

# Terraform with trace logging
def tft [...args: string] {
    let log_file = $"tf-trace-(date now | format date '%Y-%m-%dT%H:%M:%S+01').log"
    with-env {TF_LOG: "trace", TF_LOG_PATH: $log_file} {
        terraform ...$args
    }
}

# Clean all zellij sessions
def zclean [] {
    zellij kill-all-sessions
    zellij delete-all-sessions
}

# Go test coverage
def gtc [] {
    go test -covermode=count -coverpkg=./... -coverprofile _cover.out -v ./...
    go tool cover -html _cover.out -o _cover.html
}
