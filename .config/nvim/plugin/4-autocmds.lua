local function augroup(name) return vim.api.nvim_create_augroup("lee_" .. name, { clear = true }) end

-- Check if we need to reload the file when it changed.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "BufEnter" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
      -- If the file has changed and buffer is not modified, auto reload
      if vim.fn.filereadable(vim.fn.expand("%")) == 1 and not vim.bo.modified then vim.cmd("silent! e!") end
    end
  end,
})

-- Commit like magit.
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("neogit_commit"),
  pattern = { "COMMIT_EDITMSG" },
  callback = function()
    vim.keymap.set({ "n", "i" }, "<c-c><c-c>", "<esc><cmd>wq<cr>", { noremap = true, buffer = true })
    vim.keymap.set({ "n", "i" }, "<c-c><c-k>", "<esc><cmd>q!<cr>", { noremap = true, buffer = true })
  end,
})

-- Highlight on yank.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function() vim.highlight.on_yank() end,
})

-- Resize splits if window got resized.
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Set commentstring for Terraform-like files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("tf_commentstring"),
  pattern = { "hcl", "terraform", "tf", "terraform-vars", "tofu" },
  desc = "terraform/hcl commentstring configuration",
  callback = function() vim.bo.commentstring = "#\\ %s" end,
})

-- Go to last loc when opening a buffer.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then return end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- Close some filetypes with <q>.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "help",
    "lspinfo",
    "man",
    "mininotify-history",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "PlenaryTestPopup",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    if vim.bo[event.buf].filetype == "mininotify-history" then
      vim.keymap.set("n", "q", function()
        vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, {})
        vim.cmd("b#")
      end, { buffer = event.buf, silent = true })
    else
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end
  end,
})

-- Colorize some filetypes on load.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("colorize"),
  pattern = { "css", "markdown" },
  callback = function(_) require("nvim-highlight-colors").turnOn() end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
