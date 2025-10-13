if status is-interactive
    set -l is_light false

    # Check git config for light/dark preference (set by toggle script)
    if test -f ~/.config/git/config
        if grep -q "light = true" ~/.config/git/config
            set is_light true
        end
    end

    if not $is_light
        # Catppuccin Frappe (Dark)
        set -l base      303446
        set -l surface0  414559
        set -l overlay0  949cbb
        set -l subtext0  babbf1
        set -l text      c6d0f5
        set -l rosewater f2d5cf
        set -l flamingo  eebebe
        set -l pink      f4b8e4
        set -l mauve     ca9ee6
        set -l red       e78284
        set -l maroon    ea999c
        set -l peach     ef9f76
        set -l yellow    e5c890
        set -l green     a6d189
        set -l teal      81c8be
        set -l sky       99d1db
        set -l sapphire  85c1dc
        set -l blue      8caaee
        set -l lavender  babbf1

        set -g fish_pager_color_completion $blue --bold
        set -g fish_pager_color_description $subtext0 --dim
        set -g fish_pager_color_prefix $blue --bold --underline

        set -g fish_pager_color_secondary_background --background=$base
        set -g fish_pager_color_secondary_completion $mauve
        set -g fish_pager_color_secondary_description $overlay0 --dim
        set -g fish_pager_color_secondary_prefix $mauve --bold

        set -g fish_pager_color_selected_background --background=$surface0
        set -g fish_pager_color_selected_completion $flamingo --bold
        set -g fish_pager_color_selected_description $pink
        set -g fish_pager_color_selected_prefix $rosewater --underline

        set -g fish_pager_color_progress $text --background=$blue
    else
        # Catppuccin Latte (Light)
        set -l base      eff1f5
        set -l surface0  ccd0da
        set -l overlay0  8c8fa1
        set -l subtext0  6c6f85
        set -l text      4c4f69
        set -l rosewater dc8a78
        set -l flamingo  dd7878
        set -l pink      ea76cb
        set -l mauve     8839ef
        set -l red       d20f39
        set -l maroon    e64553
        set -l peach     fe640b
        set -l yellow    df8e1d
        set -l green     40a02b
        set -l teal      179299
        set -l sky       04a5e5
        set -l sapphire  209fb5
        set -l blue      1e66f5
        set -l lavender  7287fd

        set -g fish_pager_color_completion $blue --bold
        set -g fish_pager_color_description $subtext0 --dim
        set -g fish_pager_color_prefix $blue --bold --underline

        set -g fish_pager_color_secondary_background --background=$base
        set -g fish_pager_color_secondary_completion $mauve
        set -g fish_pager_color_secondary_description $overlay0 --dim
        set -g fish_pager_color_secondary_prefix $mauve --bold

        set -g fish_pager_color_selected_background --background=$surface0
        set -g fish_pager_color_selected_completion $flamingo --bold
        set -g fish_pager_color_selected_description $pink
        set -g fish_pager_color_selected_prefix $rosewater --underline

        set -g fish_pager_color_progress $text --background=$blue
    end
end
