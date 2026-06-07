#!/opt/homebrew/bin/fish --no-config
# xbar plugin: display 1m/5m/15m load averages

set load (sysctl -n vm.loadavg | string match -ra '[\d.]+')

# Catppuccin Frappe: green=#a6d189 peach=#ef9f76 red=#e78284
set l1_int (math --scale=0 $load[1])
if test $l1_int -ge 18
    set color "#e78284"
else if test $l1_int -ge 9
    set color "#ef9f76"
else
    set color "#a6d189"
end

echo "  $load[1] $load[2] $load[3] | font=VictorMonoNF-Regular color=$color"
