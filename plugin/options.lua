-- General Vim and Neovim options.

local filetypes = require("filetypes")

-- [[ Options ]]

-- Global user interface
vim.opt.shortmess:append({ I = true }) -- Disable Neovim homepage on startup
vim.o.mouse = "a" -- Enable mouse mode in all modes
vim.o.breakindent = true -- Indent parts after break in wrapped lines
vim.o.splitright = true -- Open new vertical split windows to the right
vim.o.splitbelow = true -- Open new horizontal split windows below
vim.opt.cursorline = true -- Enable hilighting of line where cursor is
vim.opt.cursorlineopt = "both" -- The cursorline highlights both the line background and the line number foreground
vim.opt.colorcolumn = "" -- No colorcolumn by default; ftplugins might change this for specific file types
vim.opt.conceallevel = 0 -- No concealing by default; ftplugins might change this for specific file types

-- Side column
vim.wo.number = true -- Enable line numbering
vim.wo.relativenumber = false -- Use absolute line numbering
vim.wo.signcolumn = "number" -- Make sign column merged in line numbering column

-- Search & replace
vim.o.ignorecase = true -- Make search case-insensitive by default
vim.o.smartcase = true -- Enable case-sensitive searching when "\C" or capital in search
vim.o.hlsearch = true -- Enable highlight on search; use `:nohlsearch` to remove the search highlight
vim.opt.inccommand = "split" -- Set split preview in incremental commands (replace/renaming)

-- Disable builtin auto-completion in favor of nvim-cmp
vim.o.complete = ""
vim.o.completeopt = ""

-- Internals
vim.o.matchpairs = vim.o.matchpairs .. ",<:>" -- Add new recognized pairs of characters
vim.o.undofile = true -- Save undo history to file
vim.o.updatetime = 250 -- Decrease delay for writting swap files
vim.o.timeout = true -- Enable timeout when receiving mapped key sequences
vim.o.timeoutlen = 300 -- Decrease delay between keys in mapped sequences

-- [[ Diagnostics ]]

-- Diagnostics configuration
vim.diagnostic.config({
  float = { border = "rounded" }, -- Settings for the "open float diagnostic" popup
  severity_sort = true, -- Display most severe diagnostic in sign column
})

-- Use symbols taken from lualine/components/diagnostics/config.lua in sign column for consistency
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- [[ Filetypes ]]

-- Add custom filetypes to those known by Neovim
vim.filetype.add({ filename = filetypes.filetype_by_filename })
