-- [[ General settings ]]

-- Disable neovim intro as it appears very briefly on startup and then disappears
vim.opt.shortmess:append({ I = true })

-- Disable builtin show mode as it is done by lualine and it messes with the macro messages
vim.opt.showmode = false

-- Status line mode
vim.o.laststatus = 3 -- Use a global status line & a thin line to separate splits

-- Display a column ruler after the 100th character
vim.o.colorcolumn = "101"

-- Support additional pairs of characters
vim.o.matchpairs = vim.o.matchpairs .. ",<:>"

-- Set highlight on search; use `:nohlsearch` to remove the search highlight
vim.o.hlsearch = true

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
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Disable builtin auto-completion (replaced by nvim-cmp)
vim.o.complete = ""
vim.o.completeopt = ""

-- Use true colors in terminal
vim.o.termguicolors = true

-- [[ Diagnostics ]]

-- Make diagnostic signs in sign column the same as in Lualine
local signs = { -- values are taken from lualine/components/diagnostics/config.lua
  Error = "󰅚 ", -- x000f015a
  Warn = "󰀪 ", -- x000f002a
  Hint = "󰌶 ", -- x000f0336
  Info = "󰋽 ", -- x000f02fd
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  float = {
    border = "rounded", -- Border of the "show diagnostic" popup
  },
  severity_sort = true, -- Display symbol for the most severe diagnostic in sign column
})

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
