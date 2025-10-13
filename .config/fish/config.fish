set -U fish_greeting

if status is-login
    if test -e /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    else if test -e /usr/local/Homebrew/bin/brew
        eval (/usr/local/Homebrew/bin/brew shellenv)
    end

    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx CARGO_HOME $HOME/.cargo
    set -gx VENVS $HOME/.venvs
    set -gx P $HOME/projects
    set -gx GOPATH $P/go
    set -gx GROOVY_HOME (brew --prefix)"/opt/groovy/libexec"
    set -gx HTML_TIDY $HOME/.config/tidy/config.txt
    set -gx VOLTA_HOME "$HOME/.volta"
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    set -gx HOMEBREW_BUNDLE_FILE "$XDG_CONFIG_HOME/brewfile/Brewfile"
    set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/ripgreprc"

    fish_add_path -m \
        (brew --prefix)/opt/coreutils/libexec/gnubin \
        /usr/local/bin \
        /usr/local/go/bin \
        $GOPATH/bin \
        $HOME/.amplify/bin \
        $HOME/.cabal/bin \
        $HOME/.cargo/bin \
        $HOME/.nimble/bin \
        $VOLTA_HOME/bin \
        $HOME/.emacs.d/bin \
        $HOME/.local/bin \
        $HOME/bin

    pyenv init - | source
    pyenv virtualenv-init - | source

    # Set LS_COLORS for colorful eza/ls output.
    # Fish completions use fish_pager_color_* instead (see conf.d/theme-enhancements.fish).
    # Only set if not already set universally by light-dark-toggle.sh.
    if not set -q LS_COLORS
        set -gx LS_COLORS (vivid generate catppuccin-frappe)
    end
end

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
    function fish_title
        echo (string replace $HOME '~' $PWD)
    end

    set fzf_diff_highlighter delta --paging=never --width=20
    set fzf_fd_opts --hidden --exclude=.git
    set fzf_preview_dir_cmd eza --all --color=always
    set --export fzf_dir_opts --bind "ctrl-e:execute(editor {} &> /dev/tty)"

    set -gx fish_vi_force_cursor 1
    set -gx fish_cursor_default block blink
    set -gx fish_cursor_insert line blink
    set -gx fish_cursor_replace_one underscore blink
    set -gx fish_cursor_visual block
    fish_vi_key_bindings
    bind -M insert --sets-mode default 'q;' repaint
    bind -M insert \cf accept-autosuggestion # Default but for vim.
    bind -M insert \ce accept-autosuggestion # Maybe better.

    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    end

    # fzf.fish history
    fzf_configure_bindings --history=\e\ch

    # atuin history
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search

    # Load abbreviations and functions.
    source ~/.config/fish/conf.d/abbreviations.fish
    source ~/.config/fish/conf.d/functions.fish

    starship init fish | source
    atuin init fish --disable-up-arrow | source

    set -Ux CARAPACE_BRIDGES 'fish,zsh,bash'
    carapace _carapace | source
end

alias ls=eza

direnv hook fish | source
zoxide init fish | source
