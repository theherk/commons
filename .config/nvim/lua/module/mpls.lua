local M = {}

local function theme_for_background() return vim.o.background == "dark" and "catppuccin-frappe" or "catppuccin-latte" end

-- (Re)configure the mpls lsp client for the current background, restarting
-- any already-running client so the new theme takes effect immediately.
-- Call this both at startup and whenever vim.o.background changes.
function M.configure()
  vim.lsp.config("mpls", {
    cmd = { "mpls", "--theme", theme_for_background(), "--enable-emoji", "--enable-footnotes" },
    filetypes = { "markdown" },
    root_markers = { ".marksman.toml", ".git" },
  })

  if #vim.lsp.get_clients({ name = "mpls" }) > 0 then
    vim.lsp.enable("mpls", false)
    vim.lsp.enable("mpls")
  end
end

function M.toggle()
  if #vim.lsp.get_clients({ name = "mpls" }) > 0 then
    vim.lsp.enable("mpls", false)
  else
    vim.lsp.enable("mpls")
  end
end

return M
