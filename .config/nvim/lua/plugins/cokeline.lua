return {
  {
    "willothy/nvim-cokeline",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function(_, _)
      local harpoon = require("harpoon.mark")
      local hlg = require("cokeline.hlgroups")
      local icons = require("config.icons").icons
      local is_picking_focus = require("cokeline.mappings").is_picking_focus
      local is_picking_close = require("cokeline.mappings").is_picking_close
      local function harpoon_icon(buffer) return harpoon.get_index_of(buffer.path) ~= nil and " 󰛢 " or "" end
      local function harpoon_sorter()
        local cache = {}

        local function marknum(buf, force)
          local b = cache[buf.number]
          if b == nil or force then
            b = harpoon.get_index_of(buf.path)
            cache[buf.number] = b
          end
          return b
        end

        harpoon.on("changed", function()
          for _, buf in ipairs(require("cokeline.buffers").get_visible()) do
            cache[buf.number] = marknum(buf, true)
          end
        end)

        return function(a, b)
          local ma = marknum(a)
          local mb = marknum(b)
          if ma and not mb then
            return true
          elseif mb and not ma then
            return false
          elseif ma ~= nil and mb ~= nil then
            return ma < mb
          end
          return a.path < b.path
        end
      end

      require("cokeline").setup({
        default_hl = {
          fg = function(buffer) return buffer.is_focused and vim.g.terminal_color_5 or hlg.get_hl_attr("Comment", "fg") end,
          bg = function(buffer) return buffer.is_focused and vim.g.terminal_color_8 or "NONE" end,
        },
        components = {
          {
            text = function(buffer) return not buffer.is_first and "|" or "" end,
            fg = function(_) return vim.g.terminal_color_4 end,
            bg = "NONE",
          },
          {
            text = " ",
          },
          {
            text = function(buffer) return (is_picking_focus() or is_picking_close()) and buffer.pick_letter .. " " or buffer.devicon.icon end,
            fg = function(buffer) return (is_picking_focus() and vim.g.terminal_color_4) or (is_picking_close() and vim.g.terminal_color_1) or buffer.devicon.color end,
            italic = function() return (is_picking_focus() or is_picking_close()) end,
            bold = function() return (is_picking_focus() or is_picking_close()) end,
          },
          {
            text = harpoon_icon,
            fg = function(_) return hlg.get_hl_attr("DiagnosticWarn", "fg") end,
          },
          {
            text = function(buffer) return (buffer.is_modified and icons.misc.Save) or (buffer.diagnostics.errors ~= 0 and icons.diagnostics.Error) or (buffer.diagnostics.warnings ~= 0 and icons.diagnostics.Warn) or "  " end,
            fg = function(buffer)
              if buffer.is_modified then
                return hlg.get_hl_attr("DiagnosticHint", "fg")
              elseif buffer.diagnostics.errors ~= 0 then
                return hlg.get_hl_attr("DiagnosticError", "fg")
              elseif buffer.diagnostics.warnings ~= 0 then
                return hlg.get_hl_attr("DiagnosticWarn", "fg")
              else
                return nil
              end
            end,
          },
          {
            text = function(buffer) return buffer.unique_prefix end,
            fg = function(_) return hlg.get_hl_attr("property", "fg") end,
            italic = true,
          },
          {
            text = function(buffer) return buffer.filename .. "  " end,
            bold = function(buffer) return buffer.is_focused end,
            italic = function(buffer) return not buffer.is_focused end,
            truncation = { priority = 99 },
          },
        },
        buffers = {
          new_buffers_position = harpoon_sorter(),
        },
        tabs = {
          -- TODO: Add tab ID's to top right.
          placement = "right",
          -- components = {},
        },
        sidebar = {
          filetype = { "NvimTree", "neo-tree" },
          components = {
            {
              text = "files",
              fg = vim.g.terminal_color_4,
              bg = function() return hlg.get_hl_attr("NvimTreeNormal", "bg") end,
            },
          },
        },
      })
    end,
  },
}
