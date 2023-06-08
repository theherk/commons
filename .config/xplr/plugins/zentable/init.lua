local xplr = xplr

local function setup()
  xplr.fn.custom.zentable_path = function(m)
    local nl = xplr.util.paint("\\n", { add_modifiers = { "Italic", "Dim" } })
    local r = m.tree .. m.prefix
    local style = xplr.util.lscolor(m.absolute_path)
    style = xplr.util.style_mix({ style, m.style })

    if m.meta.icon == nil then
      r = r .. ""
    else
      r = r .. m.meta.icon .. " "
    end

    local rel = m.relative_path
    if m.is_dir then
      rel = rel .. "/"
    end
    r = r .. xplr.util.paint(xplr.util.shell_escape(rel), style)

    r = r .. m.suffix .. " "

    if m.is_symlink then
      r = r .. "-> "

      if m.is_broken then
        r = r .. "×"
      else
        local symlink_path = xplr.util.shorten(m.symlink.absolute_path)
        if m.symlink.is_dir then
          symlink_path = symlink_path .. "/"
        end
        r = r .. symlink_path:gsub("\n", nl)
      end
    end

    return r
  end

  xplr.config.general.table.header.cols = {
    {},
  }

  xplr.config.general.default_ui.prefix = " "
  xplr.config.general.default_ui.suffix = ""

  xplr.config.general.focus_ui.prefix = "│"
  xplr.config.general.focus_ui.suffix = ""

  xplr.config.general.selection_ui.prefix = "▍"
  xplr.config.general.selection_ui.suffix = ""

  xplr.config.general.focus_selection_ui.prefix = "▌"
  xplr.config.general.focus_selection_ui.suffix = ""

  xplr.config.general.table.row.cols = {
    { format = "custom.zentable_path" },
  }

  xplr.config.general.table.col_widths = {
    { Percentage = 100 },
  }

  xplr.config.general.table.tree = {
    {},
    {},
    {},
  }
end

return { setup = setup }
