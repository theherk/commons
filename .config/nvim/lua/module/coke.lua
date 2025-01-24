local M = {}
local Harpoon = require("harpoon")
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
      if buf.path then
        ---@diagnostic disable-next-line: undefined-field
        local path = require("plenary.path"):new(buf.path):make_relative(vim.uv.cwd())
        if M.get_harpoon_index(path) then return Icons.misc.Harpoon end
      end
      return ""
    end,
    fg = function(buf)
      if not buf then return nil end
      if buf.is_modified then return hlg.get_hl_attr("DiagnosticHint", "fg") end
      if buf.diagnostics.errors ~= 0 then return hlg.get_hl_attr("DiagnosticError", "fg") end
      if buf.diagnostics.warnings ~= 0 then return hlg.get_hl_attr("DiagnosticWarn", "fg") end
      if buf.path then
        ---@diagnostic disable-next-line: undefined-field
        local path = require("plenary.path"):new(buf.path):make_relative(vim.uv.cwd())
        if M.get_harpoon_index(path) then return hlg.get_hl_attr("DiagnosticInfo", "fg") end
      end
      return nil
    end,
  }
end

function M.get_harpoon_index(path)
  local list = Harpoon:list()
  for idx, item in ipairs(list.items) do
    if item.value == path then return idx end
  end
  return nil
end

function M.harpoon_sorter()
  local cache = {}
  local setup = false
  local function marknum(buf, force)
    local b = cache[buf.number]
    if b == nil or force then
      ---@diagnostic disable-next-line: undefined-field
      local path = require("plenary.path"):new(buf.path):make_relative(vim.uv.cwd())
      for i, mark in ipairs(Harpoon:list():display()) do
        if mark == path then
          b = i
          cache[buf.number] = b
          break
        end
      end
    end
    return b
  end
  -- Use this in `config.bufs.new_bufs_position`
  return function(a, b)
    -- Only run this if harpoon is loaded, otherwise just use the default sorting.
    -- This could be used to only run if a user has harpoon installed, but
    -- I'm mainly using it to avoid loading harpoon on UiEnter.
    local has_harpoon = package.loaded["harpoon"] ~= nil
    if not has_harpoon then
      ---@diagnostic disable-next-line: undefined-field
      return a._valid_index < b._valid_index
    elseif not setup then
      local refresh = function() cache = {} end
      Harpoon:extend({
        ADD = refresh,
        REMOVE = refresh,
        REORDER = refresh,
        LIST_CHANGE = refresh,
      })
      setup = true
    end
    -- switch the a and b._valid_index to place non-harpoon bufs on the left
    -- side of the tabline - this puts them on the right.
    local ma = marknum(a)
    local mb = marknum(b)
    if ma and not mb then
      return true
    elseif mb and not ma then
      return false
    elseif ma == nil and mb == nil then
      ma = a._valid_index
      mb = b._valid_index
    end
    return ma < mb
  end
end

return M
