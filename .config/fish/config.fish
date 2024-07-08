set -U fish_greeting

if test -e /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -e /usr/local/Homebrew/bin/brew
    eval (/usr/local/Homebrew/bin/brew shellenv)
end

set -U -x EDITOR editor
set -U -x CARGO_HOME $HOME/.cargo
set -U -x VENVS $HOME/.venvs
set -U -x P $HOME/projects
set -U -x GOPATH $P/go
set -U -x HTML_TIDY $HOME/.config/tidy/config.txt
set -g -x VOLTA_HOME "$HOME/.volta"
set -g -x XDG_CONFIG_HOME "$HOME/.config"
set -g -x RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/ripgreprc"

set fzf_diff_highlighter delta --paging=never --width=20
set fzf_fd_opts --hidden --exclude=.git
set fzf_preview_dir_cmd eza --all --color=always
set --export fzf_dir_opts --bind "ctrl-e:execute(editor {} &> /dev/tty)"

fish_add_path -pP /usr/local/bin
fish_add_path -pP /usr/local/go/bin

fish_add_path -pP $HOME/.amplify/bin
fish_add_path -pP $HOME/.cabal/bin
fish_add_path -pP $HOME/.cargo/bin
fish_add_path -pP $HOME/.nimble/bin
fish_add_path -pP $GOPATH/bin
fish_add_path -pP $VOLTA_HOME/bin

fish_add_path -pP (brew --prefix)/opt/coreutils/libexec/gnubin
fish_add_path -pP $HOME/.emacs.d/bin
fish_add_path -pP $HOME/.local/bin
fish_add_path -pP $HOME/bin
fish_add_path -m (brew --prefix)/bin

# Load directory shortcuts.
if test -e ~/.dirs
    source ~/.dirs
end

# Load local machine exports.
# This is probably where you will find work related exports.
if test -e ~/.local-exports
    source ~/.local-exports
end

if status is-interactive
    set -gx fish_vi_force_cursor 1
    set -gx fish_cursor_default block blink
    set -gx fish_cursor_insert line blink
    set -gx fish_cursor_replace_one underscore blink
    set -gx fish_cursor_visual block
    fish_vi_key_bindings
    bind -M insert \cf accept-autosuggestion # Default but for vim.
    bind -M insert \ce accept-autosuggestion # Maybe better.

    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    end

    atuin init fish --disable-up-arrow | source
    starship init fish | source
    direnv hook fish | source
    pyenv init - | source
    pyenv virtualenv-init - | source
    zoxide init fish | source

    jenv init - | source
    jenv enable-plugin export >/dev/null

    # fzf.fish history
    fzf_configure_bindings --history=\e\ch

    # atuin history
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search

    abbr -a !! --position anywhere --function last_history_item
    abbr -a awsl --position command aws sso login --profile \$AWS_PROFILE
    abbr -a awsr --position command aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'
    abbr -a awsu --position command set -u AWS_PROFILE
    abbr -a awswhoami --position command aws sts get-caller-identity
    abbr -a bubu --position command "brew update && brew outdated && brew upgrade && brew cleanup"
    abbr -a c --position command codium
    abbr -a cd --position command z
    abbr -a clock --position command rsclock -c
    abbr -a d --position command 'fd -H -t d | sk'
    abbr -a dumplynx --position anywhere --set-cursor "%| lynx -dump -stdin"
    abbr -a dumpw3m --position anywhere --set-cursor "%| w3m -dump -T text/html"
    abbr -a e --position command editor
    abbr -a e10 --position command ~/nvim-macos/bin/nvim
    abbr -a ef --position command emacsclient -c -n -e "(make-frame)"
    abbr -a es --position command brew services restart emacs-plus
    abbr -a er --position command unrar e
    abbr -a ez --position command 7z e
    abbr -a fr --position command find . -iname "*.rar"
    abbr -a fz --position command find . -iname "*.7z"
    abbr -a hn --position command hackernews_tui
    abbr -a hxr --position command 'hx (sk --ansi -i -c '\''rg --color=always --hidden --line-number -g '\''!.git'\'' "{}"'\'' | cut -d: -f1-2)'
    abbr -a g --position command gitui
    abbr -a gl --position command gproxy-auto.sh
    abbr -a gtc --position command 'go test -covermode=count -coverpkg=./... -coverprofile _cover.out -v ./... && go tool cover -html _cover.out -o _cover.html'
    abbr -a gr --position command 'cd (git root)'
    abbr -a ipy --position command python -c '"import IPython; IPython.terminal.ipapp.launch_new_instance()"'
    abbr -a l --position command eza -l --icons
    abbr -a ll --position command eza -alF --icons --git --time-style long-iso
    abbr -a ls --position command eza
    abbr -a lt --position command eza -T --icons
    abbr -a lzd --position command lazydocker
    abbr -a lzg --position command lazygit
    abbr -a norcal --position command ncal -s NO -w
    abbr -a not --position command rg -v
    abbr -a of --position command onefetch
    abbr -a pc --position anywhere --set-cursor "%| pbcopy"
    abbr -a r --position command rsync -rltvz -e ssh --progress
    abbr -a rcal --position command rusti-cal -c --starting-day 1
    abbr -a slackdev --position command "export SLACK_DEVELOPER_MENU=true; open -a /Applications/Slack.app"
    abbr -a tf --position command terraform
    abbr -a tfa --position command terraform apply
    abbr -a tfd --position command terraform destroy
    abbr -a tfi --position command terraform init
    abbr -a tfiu --position command terraform init --upgrade
    abbr -a tfn --position command "gawk -f ~/bin/tfn.awk | sort"
    abbr -a tfpn --position command "gawk -f ~/bin/tfn.awk _plan | sort"
    abbr -a tfp --position command terraform plan -lock=false
    abbr -a tfpp --position command "terraform plan -lock=false | tee _plan"
    abbr -a tft --position anywhere --set-cursor="@" "TF_LOG=trace TF_LOG_PATH=tf-trace-(date +%FT%T+01).log @"
    abbr -a tn --position command trans en:no -b
    abbr -a te --position command trans no:en -b
    abbr -a tmpd --position command cd (mktemp -d)
    abbr -a up --position anywhere --set-cursor "%| underscore pretty"
    abbr -a util-list --position command "aws ec2 describe-instances --filters 'Name=tag:Name,Values=*util' --output text --query 'Reservations[*].Instances[*].InstanceId'"
    abbr -a util-list-buildhost --position command "aws ec2 describe-instances --filters 'Name=tag:Name,Values=*buildhost' --output text --query 'Reservations[*].Instances[*].InstanceId'"
    abbr -a vr --position command 'sk --ansi -i -c '\''rg --color=always --hidden --line-number -g '\''!.git'\'' "{}"'\'' | cut -d: -f1-2 | sed "s/\(.*\):\(.*\)/\+\2 \1/" | xargs nvim'
    abbr -a wezi --position command wezterm imgcat
    abbr -a wow --position command git status
    abbr -a xc --position anywhere --set-cursor "%| xclip -sel clip"
    abbr -a zp --position command zellij-project.fish

    function last_history_item
        echo $history[1]
    end

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

    function gitp # Switch to git project directory from .projects. See alias repocache.
        set REPO "$(cat "$HOME"/.projects | sed s:"$HOME":~: | fzf --reverse)"
        if test -n "$REPO"
            cd (string replace '~' $HOME $REPO)
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

    function rgh # search history
        history | rg $argv
    end

    function ssmp # get ssm parameter value
        aws ssm get-parameter --name $argv | jq -r .Parameter.Value
    end

    function ssmpd # get ssm parameter value with decryption
        aws ssm get-parameter --with-decryption --name $argv | jq -r .Parameter.Value
    end

    function t # tree with depth
        argparse --name tree --min-args 0 --max-args 1 -- $argv
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

    function venv2
        virtualenv -p /usr/bin/python2 .venv
        venvact .venv
        pip install ipython
    end

    function venv3
        python3 -m venv .venv
        venvact .venv
        pip install ipython
    end

    function venvact
        source .venv/bin/activate
    end

    # Unsure about this; fits the theme, but extra keystrokes.
    # function fish_greeting
    #     wezterm imgcat --position (math "($COLUMNS - 20) /2"),6 --hold ~/commons/img/bruce-matlocktheartist_400w.png
    # end
end

alias ls=eza
