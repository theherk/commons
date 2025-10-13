# AWS aliases
alias awsl = aws sso login --profile $env.AWS_PROFILE
alias awsr = aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'
alias awswhoami = aws sts get-caller-identity
alias util-list = aws ec2 describe-instances --filters 'Name=tag:Name,Values=*util' 'Name=instance-state-name,Values=pending,running,stopping,stopped' --output text --query 'Reservations[*].Instances[*].InstanceId'
alias util-list-buildhost = aws ec2 describe-instances --filters 'Name=tag:Name,Values=*buildhost' 'Name=instance-state-name,Values=pending,running,stopping,stopped' --output text --query 'Reservations[*].Instances[*].InstanceId'
alias util-list-cdc = aws ec2 describe-instances --filters 'Name=tag:Name,Values=*cdc*' 'Name=instance-state-name,Values=pending,running,stopping,stopped' --output text --query 'Reservations[*].Instances[*].InstanceId'

# Git aliases
alias gr = cd (git root)
alias lzg = lazygit
alias wow = git status

# Terraform aliases
alias tf = terraform
alias tfa = terraform apply
alias tfd = terraform destroy
alias tfi = terraform init
alias tfiu = terraform init --upgrade
alias tfn = gawk -f ~/bin/tfn.awk | sort
alias tfp = terraform plan -lock=false
alias tfpn = gawk -f ~/bin/tfn.awk _plan | sort
alias tfpp = terraform plan -lock=false | tee _plan

# File listing (using eza)
alias l = eza -l --icons
alias ll = eza -alF --icons --git --time-style long-iso
alias lt = eza -T --icons

# Docker/Podman
alias lzd = lazydocker

# Calendar
alias norcal = ncal -s NO -w
alias rcal = rusti-cal -c --starting-day 1

# Clock
alias clock = rsclock -c

# HackerNews
alias hn = hackernews_tui

# Utilities
alias of = onefetch
alias r = rsync -rltvz -e ssh --progress
alias tmpd = cd (mktemp -d)

# IPython
alias ipy = python -c "import IPython; IPython.terminal.ipapp.launch_new_instance()"
