#!/usr/bin/env bash
# @tuna.name List Projects
# @tuna.subtitle List git projects for workspace switching
# @tuna.mode inline
# @tuna.output text
set -euo pipefail

zoxide query -l | rg --color=never -FxNf ~/.projects | sed "s:$HOME:~:"
