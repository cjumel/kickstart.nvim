-- [[ Leader key ]]
-- Unmap <space>
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Set <space> as the leader key; it must happen before plugins are required
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Plugins ]]
-- Install lazy.nvim package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Automatically add your plugins, configuration, etc from `lua/plugins/*.lua`
require('lazy').setup({ { import = 'plugins' } }, {})

-- [[ Setting options ]]
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Use true colors in terminal
vim.o.termguicolors = true

-- Colorize the column corresponding to a 100-character line length
vim.o.colorcolumn = '100'

-- When scrolling up or down, always keep a few lines between the cursor and the page limit
vim.o.scrolloff = 3

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Basic Keymaps ]]
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ 'n', 'o', 'x' }, 'gg', 'gg0', { desc = 'Beginning buffer' })
vim.keymap.set({ 'n', 'o', 'x' }, 'G', 'G$', { desc = 'End of buffer' })

-- Window splits
vim.keymap.set('n', '<leader>v', '<cmd> vsplit <CR>', { desc = '[V]ertical Split' })
vim.keymap.set('n', '<leader>s', '<cmd> split <CR>', { desc = '(Horizontal) [S]plit' })

-- Use tab in visual mode to indent
vim.keymap.set('v', '<tab>', '>gv', { desc = 'Indent selection' })
vim.keymap.set('v', '<s-tab>', '<gv', { desc = 'Unindent selection' })

-- Close buffer
vim.keymap.set('n', '<leader>q', '<cmd> bd <CR>', { desc = '[Q]uit Buffer' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_next, { desc = '[[] Next [D]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, { desc = '[]] Previous [D]iagnostic' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.open_float, { desc = '[D]iagnostics: [P]review' })

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
