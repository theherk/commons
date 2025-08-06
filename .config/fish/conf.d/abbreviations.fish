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
abbr -a ef --position command emacsclient -c -n -e "(make-frame)"
abbr -a es --position command brew services restart emacs-plus
abbr -a er --position command unrar e
abbr -a ez --position command 7z e
abbr -a fr --position command find . -iname "*.rar"
abbr -a fz --position command find . -iname "*.7z"
abbr -a ghe --position command --set-cursor="@" "gh @ --hostname $GH_HOST" # GH_HOST set in ~/.local-exports
abbr -a gl --position command gproxy-auto.sh
abbr -a gtc --position command 'go test -covermode=count -coverpkg=./... -coverprofile _cover.out -v ./... && go tool cover -html _cover.out -o _cover.html'
abbr -a gr --position command 'cd (git root)'
abbr -a hn --position command hackernews_tui
abbr -a hxr --position command 'hx (sk --ansi -i -c '\''rg --color=always --hidden --line-number -g '\''!.git'\'' "{}"'\'' | cut -d: -f1-2)'
abbr -a ipy --position command python -c '"import IPython; IPython.terminal.ipapp.launch_new_instance()"'
abbr -a l --position command eza -l --icons
abbr -a ll --position command eza -alF --icons --git --time-style long-iso
abbr -a ls --position command eza
abbr -a lt --position command eza -T --icons
abbr -a lzd --position command lazydocker
abbr -a lzg --position command lazygit
abbr -a lzp --position command 'DOCKER_HOST=unix:///var/folders/ld/ktvj7qn96mj_s3pb81m50h1w0000gn/T/podman/podman-machine-default-api.sock lazydocker' # value from podman desktop
abbr -a norcal --position command ncal -s NO -w
abbr -a not --position command rg -v
abbr -a nv --position command neovide --fork
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
abbr -a util-list --position command "aws ec2 describe-instances --filters 'Name=tag:Name,Values=*util' 'Name=instance-state-name,Values=pending,running,stopping,stopped' --output text --query 'Reservations[*].Instances[*].InstanceId'"
abbr -a util-list-buildhost --position command "aws ec2 describe-instances --filters 'Name=tag:Name,Values=*buildhost' 'Name=instance-state-name,Values=pending,running,stopping,stopped' --output text --query 'Reservations[*].Instances[*].InstanceId'"
abbr -a util-list-cdc --position command "aws ec2 describe-instances --filters 'Name=tag:Name,Values=*cdc*' 'Name=instance-state-name,Values=pending,running,stopping,stopped' --output text --query 'Reservations[*].Instances[*].InstanceId'"
abbr -a vr --position command 'sk --ansi -i -c '\''rg --color=always --hidden --line-number -g '\''!.git'\'' "{}"'\'' | cut -d: -f1-2 | sed "s/\(.*\):\(.*\)/\+\2 \1/" | xargs nvim'
abbr -a wezi --position command wezterm imgcat
abbr -a wow --position command git status
abbr -a xc --position anywhere --set-cursor "%| xclip -sel clip"
abbr -a zp --position command zellij-project.fish
abbr -a zclean --position command 'begin; zellij kill-all-sessions; zellij delete-all-sessions; end'
