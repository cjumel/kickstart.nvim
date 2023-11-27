-- [[ Setting options ]]

-- Disable neovim intro as it appears very briefly on startup and then disappears
vim.opt.shortmess:append({ I = true })

-- Disable builtin show mode as it is done by lualine and it messes with the macro messages
vim.opt.showmode = false

-- Status line mode
vim.o.laststatus = require("statusline").laststatus

-- Display a column ruler after the 100th character
vim.o.colorcolumn = "101"

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Merge signcolumn and number column
vim.wo.signcolumn = "number"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Disable builtin auto-completion (replaced by nvim-cmp)
vim.o.complete = ""
vim.o.completeopt = ""

-- Use true colors in terminal
vim.o.termguicolors = true

-- Add a bborder to the diagnostics popup (especially useful for transparent background)
vim.diagnostic.config({ float = { border = "rounded" } })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- vim: ts=2 sts=2 sw=2 et
