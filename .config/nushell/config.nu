$env.config = {
    show_banner: false

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    error_style: "fancy"

    cursor_shape: {
        vi_insert: line
        vi_normal: block
    }

    use_grid_icons: true
    use_ansi_coloring: true
    bracketed_paste: true # enable bracketed paste, currently useless on windows
    edit_mode: vi
    hooks: {
      pre_prompt: [{ ||
        if (which direnv | is-empty) {
          return
        }

        direnv export json | from json | default {} | load-env
      }]
    }
}
use ~/.cache/starship/init.nu
