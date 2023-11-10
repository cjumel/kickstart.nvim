-- [[ Leader key ]]

-- Set <space> as the leader key; it must happen before plugins are required
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Plugins ]]
-- Install lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Automatically add your plugins, configuration, etc from `lua/plugins/` directory
require("lazy").setup({
  -- Plugins related to code (LSP, completion, debugging, etc.)
  { import = "plugins.code" },
  { import = "plugins.code.dap" },
  -- Plugins related to simple editions (highlighting, motions, text objects, etc.)
  { import = "plugins.edition" },
  { import = "plugins.edition.treesitter" },
  -- Plugins related to code navigation (fuzzy finding, file tree navigation, etc.)
  { import = "plugins.navigation" },
  { import = "plugins.navigation.telescope" },
  -- Plugins related to the user interface (color scheme, visual elements, etc.)
  { import = "plugins.ui" },
  -- Plugins related to the global workflow with external tools (git, tests, external package manager, etc.)
  { import = "plugins.workflow" },
  { import = "plugins.workflow.vcs" },
}, {})

-- [[ Setting options ]]

-- Disable neovim intro as it appears very briefly on startup and then disappears
vim.opt.shortmess:append({ I = true })

-- Disable builtin show mode as it is done by lualine and it messes with the macro messages
vim.opt.showmode = false

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Display a column ruler after the 100th character
vim.o.colorcolumn = "101"

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Disable builtin auto-completion (replaced by nvim-cmp)
vim.o.complete = ""
vim.o.completeopt = ""

-- Use true colors in terminal
vim.o.termguicolors = true

-- [[ Basic keymaps ]]

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Disable builtin auto-completion keymaps (avoid writting letters when calling them)
vim.keymap.set("i", "<C-n>", "<Nop>", { silent = true })
vim.keymap.set("i", "<C-p>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ "n", "o", "x" }, "gg", "gg0", { desc = "Beginning buffer" })
vim.keymap.set({ "n", "o", "x" }, "G", "G$", { desc = "End of buffer" })

-- Use tab in visual mode to indent
vim.keymap.set("v", "<tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<s-tab>", "<gv", { desc = "Unindent selection" })

-- Shortcuts to access main registers
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System copy register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole copy register" })
vim.keymap.set({ "n", "v" }, "Q", "@q", { desc = "Default macro register" })

-- Diagnostics
vim.keymap.set("n", "<leader>?", vim.diagnostic.open_float, { desc = "[?] Expand diagnostic" })

-- Quick files
vim.keymap.set("n", "<leader>qn", function()
  vim.cmd("edit ./notes.md")
end, { desc = "[Q]uick file: [N]otes" })
vim.keymap.set("n", "<leader>qp", function()
  vim.cmd("edit ./temp.py")
end, { desc = "[Q]uick file: [P]ython" })

-- Use <c-p> and <c-n> in command line to navigate through command line history matching the current input
vim.keymap.set("c", "<c-p>", "<up>")
vim.keymap.set("c", "<c-n>", "<down>")

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
