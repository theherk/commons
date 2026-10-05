#!/opt/homebrew/bin/fish --no-config
# xbar plugin: display battery percent and local time (HH:MM, 24h)

set line (pmset -g batt | string match -r '\d+%;.*')
set pct (string match -r '^\d+' $line)

# Catppuccin palette: Frappe (dark) / Latte (light)
# Battery icon uses the level color, clock icon is lavender; text uses the "text" color (ANSI truecolor)
if defaults read -g AppleInterfaceStyle &>/dev/null
    set green "166;209;137"
    set peach "239;159;118"
    set red "231;130;132"
    set text "198;208;245"
    set lavender "186;187;241"
else
    set green "64;160;43"
    set peach "254;100;11"
    set red "210;15;57"
    set text "76;79;105"
    set lavender "114;135;253"
end

if test $pct -lt 20
    set color $red
    set glyph 󰂎
else if test $pct -lt 50
    set color $peach
    set glyph 󰂃
else
    set color $green
    set glyph 󰁹
end

set t (date +%H:%M)

set esc (printf '\e')
set icon $esc"[38;2;"$color"m"
set clock $esc"[38;2;"$lavender"m"
set txt $esc"[38;2;"$text"m"

echo "$icon$glyph $txt$pct $clock󰥔 $txt$t | font=VictorMonoNF-Regular ansi=true"
