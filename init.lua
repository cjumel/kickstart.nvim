-- [[ Leader key ]]
-- Unmap <space>
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

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

-- Automatically add your plugins, configuration, etc from `lua/plugins/*.lua`
require("lazy").setup({ { import = "plugins" } }, {})

-- [[ Setting options ]]

-- Disable neovim intro as it appears very briefly on startup and then disappears
vim.opt.shortmess:append({ I = true })

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

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

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Use true colors in terminal
vim.o.termguicolors = true

-- [[ Basic keymaps ]]

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ "n", "o", "x" }, "gg", "gg0", { desc = "Beginning buffer" })
vim.keymap.set({ "n", "o", "x" }, "G", "G$", { desc = "End of buffer" })

-- Use tab in visual mode to indent
vim.keymap.set("v", "<tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<s-tab>", "<gv", { desc = "Unindent selection" })

-- Diagnostics
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "[D]iagnostics: [E]xpand" })

-- Quick notes
vim.keymap.set("n", "<leader>qn", function()
  vim.cmd("edit ./notes.md")
end, { desc = "[Q]uick: [N]otes" })

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
