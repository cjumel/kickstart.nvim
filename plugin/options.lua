-- General Vim options

-- Disable neovim intro as it appears very briefly on startup and then disappears
vim.opt.shortmess:append({ I = true })

-- Disable builtin show mode as it is done by lualine and it messes with the macro messages
vim.opt.showmode = false

-- Status line mode
vim.o.laststatus = 3 -- Use a global status line & a thin line to separate splits

-- Support additional pairs of characters
vim.o.matchpairs = vim.o.matchpairs .. ",<:>"

-- Set highlight on search; use `:nohlsearch` to remove the search highlight
vim.o.hlsearch = true

-- Set split preview in incremental commands (replace/renaming)
vim.opt.inccommand = "split"

-- Line numbering
vim.wo.number = true
vim.wo.relativenumber = false

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
