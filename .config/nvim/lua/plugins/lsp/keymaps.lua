local M = {}

local Util = require("config.util")

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  local format = function() require("plugins.lsp.format").format({ force = true }) end
  if not M._keys then
    ---@class PluginLspKeys
    -- stylua: ignore
    M._keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "lsp info" },
      { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "goto def", has = "definition" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "telescope refs" },
      { "gD", vim.lsp.buf.declaration, desc = "goto declaration" },
      { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "show impl" },
      { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "type def" },
      { "K", vim.lsp.buf.hover, desc = "hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "sig help", has = "signature help" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "sig help", has = "signature help" },
      { "<leader>cf", format, desc = "format doc", has = "formatting" },
      { "<leader>cf", format, desc = "format range", mode = "v", has = "range formatting" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "action", mode = { "n", "v" }, has = "code action" },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "src action",
        has = "codeAction",
      }
    }
    if require("config.util").has("inc-rename.nvim") then
      M._keys[#M._keys + 1] = {
        "<leader>cr",
        function()
          local inc_rename = require("inc_rename")
          return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "rename",
        has = "rename",
      }
    else
      M._keys[#M._keys + 1] = { "<leader>cr", vim.lsp.buf.rename, desc = "rename", has = "rename" }
    end
  end
  return M._keys
end

---@param method string
function M.has(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = Util.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then return true end
  end
  return false
end

function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  local function add(keymap)
    local keys = Keys.parse(keymap)
    if keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end
  for _, keymap in ipairs(M.get()) do
    add(keymap)
  end

  local opts = require("config.util").opts("nvim-lspconfig")
  local clients = Util.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    for _, keymap in ipairs(maps) do
      add(keymap)
    end
  end
  return keymaps
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go({ severity = severity }) end
end

return M
