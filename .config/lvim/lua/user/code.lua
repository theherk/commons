lvim.format_on_save = {
  enabled = true,
  pattern = "*",
  timeout = 1000,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

-- Look like this may not be needed.
-- local lsp = require("lsp-zero")
-- lsp.configure("yamlls", {
--   settings = {
--     yaml = {
--       keyOrdering = false
--     }
--   }
-- })

-- -- linters, formatters and code actions <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "goimports",
    filetypes = { "go" },
  },
  {
    command = "terraform_fmt",
    filetypes = { "hcl", "terraform", "tf" },
  },
  {
    command = "black",
    filetypes = { "python" },
  },
  {
    command = "prettier",
    extra_args = { "--print-width", "100" },
    filetypes = { "javascript", "typescript", "typescriptreact" },
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    command = "flake8",
    filetypes = { "python" },
  },
  {
    command = "terraform_validate",
    filetypes = { "terraform", "tf" },
  },
  {
    command = "shellcheck",
    args = { "--severity", "warning" },
  },
  {
    command = "zsh",
    filetypes = { "zsh" },
  },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    exe = "eslint",
    filetypes = { "javascript", "typescript", "typescriptreact" },
  },
}

lvim.builtin.dap.active = true
local dap = require("dap")
dap.adapters.go = function(callback, _)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 38697
  local opts = {
    stdio = { nil, stdout },
    args = { "dap", "-l", "127.0.0.1:" .. port },
    detached = true,
  }
  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then
      print("dlv exited with code", code)
    end
  end)
  assert(handle, "Error running dlv: " .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
  -- Wait for delve to start
  vim.defer_fn(function()
    callback { type = "server", host = "127.0.0.1", port = port }
  end, 100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  -- works with go.mod packages and sub packages
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}
