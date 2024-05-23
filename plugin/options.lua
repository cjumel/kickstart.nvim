-- General Vim options

-- Global user interface
vim.opt.shortmess:append({ I = true }) -- Disable Neovim homepage on startup
vim.o.mouse = "a" -- Enable mouse mode in all modes
vim.o.breakindent = true -- Indent parts after break in wrapped lines

-- Status line
vim.o.laststatus = 3 -- Use a single global status line for all splits
vim.opt.showmode = false -- Don't show mode in status line as it is redundant with Lualine's onw feature

-- Side column
vim.wo.number = true -- Enable line numbering
vim.wo.relativenumber = false -- Keep line numbering absolute
vim.wo.signcolumn = "number" -- Merge signcolumn in line numbering column

-- Search & replace
vim.o.ignorecase = true -- Make search case-insensitive by default
vim.o.smartcase = true -- Enable case-sensitive searching when "\C" or capital in search
vim.o.hlsearch = true -- Enable highlight on search; use `:nohlsearch` to remove the search highlight
vim.opt.inccommand = "split" -- Set split preview in incremental commands (replace/renaming)

-- Disable builtin auto-completion in favor of nvim-cmp
vim.o.complete = ""
vim.o.completeopt = ""

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use Treesitter folding
vim.opt.foldtext = "" -- Use transparent fold (show first line of the fold, with highlights)
vim.opt.fillchars:append({ fold = " " }) -- Don't fill folded lines with characters
vim.opt.foldlevelstart = 99 -- Start with all folds open

-- Internals
vim.o.matchpairs = vim.o.matchpairs .. ",<:>" -- Add new recognized pairs of characters
vim.o.undofile = true -- Save undo history to file
vim.o.updatetime = 250 -- Decrease delay for writting swap files
vim.o.timeout = true -- Enable timeout when receiving mapped key sequences
vim.o.timeoutlen = 300 -- Decrease delay between keys in mapped sequences
