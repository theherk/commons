set -U fish_greeting
set -U -x EDITOR hx
set -U -x CARGO_HOME $HOME/.cargo
set -U -x VENVS $HOME/.venvs
set -U -x P $HOME/projects
set -U -x GOPATH $P/go
set -U -x JAVA_HOME (/usr/libexec/java_home)

fish_add_path -pP /usr/local/bin
fish_add_path -pP /usr/local/go/bin

fish_add_path -pP $HOME/.amplify/bin
fish_add_path -pP $HOME/.cabal/bin
fish_add_path -pP $HOME/.cargo/bin
fish_add_path -pP $HOME/.nimble/bin
fish_add_path -pP $GOPATH/bin

fish_add_path -pP $HOME/.emacs.d/bin
fish_add_path -pP $HOME/bin

if status is-interactive
    # On ARM MacOS homebrew uses some different paths,
    # Generally this is found in:
    # /usr/local/opt/coreutils/libexec/gnubin
    # But on M1, it is exported from:
    # /opt/homebrew/opt/coreutils/libexec/gnubin
    if test -d /opt/homebrew/opt/coreutils/libexec/gnubin
        fish_add_path -pP /opt/homebrew/opt/coreutils/libexec/gnubin
    else if test -d /usr/local/Homebrew/opt/coreutils/libexec/gnubin
        fish_add_path -pP /usr/local/Homebrew/opt/coreutils/libexec/gnubin
    end

    if test -e /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    else if test -e /usr/local/Homebrew/bin/brew
        eval (/usr/local/Homebrew/bin/brew shellenv)
    end

    starship init fish | source
    direnv hook fish | source
    status --is-interactive; and pyenv init - | source
    status --is-interactive; and pyenv virtualenv-init - | source
    abbr -a !! --position anywhere --function last_history_item
    abbr -a awsl --position command aws sso login --profile \$AWS_PROFILE
    abbr -a awsr --position command aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'
    abbr -a awsu --position command unset AWS_PROFILE
    abbr -a bubu --position command "brew update && brew outdated && brew upgrade && brew cleanup"
    abbr -a clock --position command rsclock -c
    abbr -a dumplynx --position anywhere --set-cursor "%| lynx -dump -stdin"
    abbr -a dumpw3m --position anywhere --set-cursor "%| w3m -dump -T text/html"
    abbr -a ef --position command emacsclient -c -n -e "(make-frame)"
    abbr -a es --position command brew services restart emacs-plus
    abbr -a er --position command unrar e
    abbr -a ez --position command 7z e
    abbr -a fr --position command find . -iname "*.rar"
    abbr -a fz --position command find . -iname "*.7z"
    abbr -a hxr --position command 'hx (sk --ansi -i -c '\''rg --color=always --hidden --line-number -g '\''!.git'\'' "{}"'\'' | cut -d: -f1-2)'
    abbr -a g --position command gitui
    abbr -a gl --position command gproxy-auto.sh
    abbr -a ipy --position command python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'
    abbr -a l --position command exa -l --icons
    abbr -a lg --position command lazygit
    abbr -a ll --position command exa -alF --icons --git --time-style long-iso
    abbr -a ls --position command exa
    abbr -a lt --position command exa -T --icons
    abbr -a norcal --position command ncal -s NO -w
    abbr -a of --position command onefetch
    abbr -a pc --position anywhere --set-cursor "%| pbcopy"
    abbr -a r --position command rsync -rltvz -e ssh --progress
    abbr -a rcal --position command rusti-cal -c --starting-day 1
    abbr -a tfa --position command terraform apply
    abbr -a tfd --position command terraform destroy
    abbr -a tfi --position command terraform init
    abbr -a tfiu --position command terraform init --upgrade
    abbr -a tfn --position command "gawk -f ~/bin/tfn.awk | sort"
    abbr -a tfpn --position command "gawk -f ~/bin/tfn.awk _plan | sort"
    abbr -a tfp --position command terraform plan
    abbr -a tfpp --position command "terraform plan | tee _plan"
    abbr -a tft --position anywhere --set-cursor "TF_LOG=trace TF_LOG_PATH=tf-trace-(date +%FT%T+01).log %"
    abbr -a tn --position command trans en:no -b
    abbr -a te --position command trans no:en -b
    abbr -a tmpd --position command cd (mktemp -d)
    abbr -a up --position anywhere --set-cursor "%| underscore pretty"
    abbr -a util-list --position command "aws ec2 describe-instances --filters 'Name=tag:Name,Values=*util' --output text --query 'Reservations[*].Instances[*].InstanceId'"
    abbr -a util-list-buildhost --position command "aws ec2 describe-instances --filters 'Name=tag:Name,Values=*buildhost' --output text --query 'Reservations[*].Instances[*].InstanceId'"
    abbr -a wow --position command git status
    abbr -a xc --position anywhere --set-cursor "%| xclip -sel clip"

    function last_history_item
        echo $history[1]
    end

    function awsp # Set AWS_PROFILE
        argparse --min-args 1 --max-args 1 -- $argv
        or return
        echo $argv
        export AWS_PROFILE=$argv
    end

    function pwa # add password to keyring
        argparse --min-args 2 --max-args 2 -- $argv
        security add-generic-password -s $argv[0] -a $argv[1] -w
    end

    function pwf # find password in keyring
        argparse --min-args 2 --max-args 2 -- $argv
        security find-generic-password -w -s $argv[0] -a $argv[1]
    end

    function rgh # search history
        history | rg $argv
    end

    function t # tree with depth
        argparse --name tree --min-args 0 --max-args 1 -- $argv
        if test (count $argv) -lt 1
            exa -T
        else
            exa -T -L $argv
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

    function mkdir -d "Create a directory and set CWD"
        command mkdir $argv
        if test $status = 0
            switch $argv[(count $argv)]
                case '-*'

                case '*'
                    cd $argv[(count $argv)]
                    return
            end
        end
    end
end
