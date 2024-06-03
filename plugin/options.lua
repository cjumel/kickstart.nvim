-- General Vim options

-- Global user interface
vim.opt.shortmess:append({ I = true }) -- Disable Neovim homepage on startup
vim.o.mouse = "a" -- Enable mouse mode in all modes
vim.o.breakindent = true -- Indent parts after break in wrapped lines
vim.o.splitright = true -- Open new vertical split windows to the right
vim.o.splitbelow = true -- Open new horizontal split windows below

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

-- Callback to disable tooling in some location
vim.g.disable_tooling_callback = function(file_path)
  return file_path:match("/.venv/") -- Virtual environments
    or (file_path:match("^~/%..*/") and not file_path:match("^~/%.config/")) -- Hidden $HOME sub-directories
    or file_path:match("^~/Library/Caches/") -- Dependencies installed by package managers like `pip` or `poetry`
end
