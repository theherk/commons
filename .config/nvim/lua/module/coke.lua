local M = {}
local Icons = require("module.icons")

function M.component_gap() return { text = " " } end

function M.component_icon()
  local focusing = require("cokeline.mappings").is_picking_focus
  local closing = require("cokeline.mappings").is_picking_close
  return {
    text = function(buffer) return (focusing() or closing()) and buffer.pick_letter or buffer.devicon.icon or " " end,
    fg = function(buffer) return (focusing() and vim.g.terminal_color_4) or (closing() and vim.g.terminal_color_1) or buffer.devicon.color or nil end,
    italic = function() return (focusing() or closing()) end,
    bold = function() return (focusing() or closing()) end,
  }
end

function M.component_name()
  return {
    text = function(buf) return buf.unique_prefix .. (buf.filename or "[ ]") end,
    bold = function(buf) return buf.is_focused end,
    italic = function(buf) return not buf.is_focused end,
    truncation = { priority = 99 },
  }
end

function M.component_status()
  local hlg = require("cokeline.hlgroups")
  return {
    text = function(buf)
      if not buf then return "" end
      if buf.is_modified then return Icons.misc.Save end
      if buf.diagnostics.errors ~= 0 then return Icons.diagnostics.Error end
      if buf.diagnostics.warnings ~= 0 then return Icons.diagnostics.Warn end
      return ""
    end,
    fg = function(buf)
      if not buf then return nil end
      if buf.is_modified then return hlg.get_hl_attr("DiagnosticHint", "fg") end
      if buf.diagnostics.errors ~= 0 then return hlg.get_hl_attr("DiagnosticError", "fg") end
      if buf.diagnostics.warnings ~= 0 then return hlg.get_hl_attr("DiagnosticWarn", "fg") end
      return nil
    end,
  }
end

return M
