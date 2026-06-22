#!/opt/homebrew/bin/fish --no-config
# xbar plugin: display 1m/5m/15m load averages

set load (sysctl -n vm.loadavg | string match -ra '[\d.]+')

# Detect appearance and pick Catppuccin palette
# Frappe (dark): green=#a6d189 peach=#ef9f76 red=#e78284
# Latte (light): green=#40a02b peach=#fe640b red=#d20f39
if defaults read -g AppleInterfaceStyle &>/dev/null
    set green "#a6d189"
    set peach "#ef9f76"
    set red "#e78284"
else
    set green "#40a02b"
    set peach "#fe640b"
    set red "#d20f39"
end

set l1_int (math --scale=0 $load[1])
if test $l1_int -ge 18
    set color $red
else if test $l1_int -ge 9
    set color $peach
else
    set color $green
end

echo "  $load[1] $load[2] $load[3] | font=VictorMonoNF-Regular color=$color"
