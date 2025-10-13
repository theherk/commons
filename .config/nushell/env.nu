if ('/opt/homebrew/bin/brew' | path exists) {
    /opt/homebrew/bin/brew shellenv | lines | each { |line|
        let parts = ($line | parse 'export {name}="{value}"')
        if ($parts | length) > 0 {
            load-env {($parts.0.name): ($parts.0.value)}
        }
    } | ignore
    $env.PATH = ($env.PATH | prepend '/opt/homebrew/bin')
} else if ('/usr/local/Homebrew/bin/brew' | path exists) {
    /usr/local/Homebrew/bin/brew shellenv | lines | each { |line|
        let parts = ($line | parse 'export {name}="{value}"')
        if ($parts | length) > 0 {
            load-env {($parts.0.name): ($parts.0.value)}
        }
    } | ignore
    $env.PATH = ($env.PATH | prepend '/usr/local/Homebrew/bin')
}

$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'

$env.CARGO_HOME = $'($env.HOME)/.cargo'
$env.VENVS = $'($env.HOME)/.venvs'
$env.P = $'($env.HOME)/projects'
$env.GOPATH = $'($env.P)/go'
$env.VOLTA_HOME = $'($env.HOME)/.volta'
$env.XDG_CONFIG_HOME = $'($env.HOME)/.config'

# Tool-specific configs
$env.HOMEBREW_BUNDLE_FILE = $'($env.XDG_CONFIG_HOME)/brewfile/Brewfile'
$env.RIPGREP_CONFIG_PATH = $'($env.XDG_CONFIG_HOME)/ripgrep/ripgreprc'
$env.HTML_TIDY = $'($env.HOME)/.config/tidy/config.txt'

# PATH setup - prepend directories (last item has highest priority)
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    $'($env.HOME)/bin'
    $'($env.HOME)/.local/bin'
    $'($env.HOME)/.emacs.d/bin'
    $'($env.VOLTA_HOME)/bin'
    $'($env.HOME)/.nimble/bin'
    $'($env.HOME)/.cargo/bin'
    $'($env.HOME)/.cabal/bin'
    $'($env.HOME)/.amplify/bin'
    $'($env.GOPATH)/bin'
    '/usr/local/go/bin'
    '/usr/local/bin'
])

if (which brew | length) > 0 {
    let coreutils_path = $"(brew --prefix)/opt/coreutils/libexec/gnubin"
    if ($coreutils_path | path exists) {
        $env.PATH = ($env.PATH | prepend $coreutils_path)
    }
}

if ('~/.dirs.nu' | path expand | path exists) {
    source ~/.dirs.nu
}

if ('~/.local-exports.nu' | path expand | path exists) {
    source ~/.local-exports.nu
}

# Initialize tool caches
mkdir $"($nu.cache-dir)/atuin"
mkdir $"($nu.cache-dir)/carapace"
mkdir $"($nu.cache-dir)/starship"
mkdir $"($nu.cache-dir)/zoxide"

atuin init nu --disable-up-arrow | save -f $"($nu.cache-dir)/atuin/init.nu"
carapace _carapace nushell | save -f $"($nu.cache-dir)/carapace/init.nu"
starship init nu | save -f $"($nu.cache-dir)/starship/init.nu"
zoxide init nushell | save -f $"($nu.cache-dir)/zoxide/init.nu"
