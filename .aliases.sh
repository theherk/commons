alias awsl='aws sso login --profile $AWS_PROFILE'
alias awsr="aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'"
alias awsu='unset AWS_PROFILE'
alias cd=z
alias clock='rsclock -c'
alias dumplynx='lynx -dump -stdin'
alias dumpw3m='w3m -dump -T text/html'
alias e='editor'
alias ef='emacsclient -c -n -e "(make-frame)"'
alias es='brew services restart emacs-plus'
alias er='unrar e'
alias ez='7z e'
alias fr='find . -iname "*.rar"'
alias fz='find . -iname "*.7z"'
alias g='gitui'
alias gl='gproxy-auto.sh'
alias gr='cd $(git root)'
alias hxr='hx $(sk --ansi -i -c '\''rg --color=always --hidden --line-number -g '\''!.git'\'' "{}"'\'' | cut -d: -f1-2)'
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
alias l='eza -l --icons'
alias ll='eza -alF --icons --git --time-style long-iso'
alias ls='eza'
alias lt='eza -T --icons'
alias lzd='lazydocker'
alias lzg='lazygit'
alias norcal='ncal -s NO -w'
alias not='rg -v'
alias r="rsync -rltvz -e ssh --progress"
alias rcal='rusti-cal -c --starting-day 1'
alias tfn='gawk '"'"'match($0, /# (\S+\.(\[.+\]|\S+)+)/, g) { m=g[1]; l=$0 } match($0, /^(.* )resource .*{$/, g) { if (l!~/has changed/ && l!~/will be read/) print g[1] m }'"'"' | sort'
alias tfp='terraform plan -lock=false'
alias tfpn='bat _plan | tfn'
alias tfpp='tfp | tee _plan'
alias tft='TF_LOG=trace TF_LOG_PATH=tf-trace-$(date +%FT%T+01).log'
alias tfw='rg --color never "will be|must be" | rg -v "will be read" | sed "s/ be /|/g" | sort -t "|" -k2 | awk '"'"'BEGIN{FS="|"}{o=$NF!=a&&a?"\n"$2"\n"$1:!a?$2"\n"$1:$1;a=$NF;print o}'"'"' | sed -E "s/ will| must//" | sed "s/# //"'
alias tn="trans en:no -b "
alias te="trans no:en -b "
alias tmpd='cd $(mktemp -d)'
alias up="underscore pretty"
alias util-list="aws ec2 describe-instances --filters 'Name=tag:Name,Values=*util' --output text --query 'Reservations[*].Instances[*].InstanceId'"
alias util-list-buildhost="aws ec2 describe-instances --filters 'Name=tag:Name,Values=*buildhost' --output text --query 'Reservations[*].Instances[*].InstanceId'"
alias vr='sk --ansi -i -c '\''rg --color=always --hidden --line-number -g '\''!.git'\'' "{}"'\'' | cut -d: -f1-2 | sed "s/\(.*\):\(.*\)/\+\2 \1/" | xargs nvim'
alias wezy='wezterm imgcat'
alias wow="git status"
alias xc='xclip -sel clip'
alias xp='cat p|xc'
