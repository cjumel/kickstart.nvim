-- Nvim-tree
--
-- A file tree explorer for nvim written in Lua.

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = true,
  cmd = { 'NvimTreeFocus' },
  init = function()
    vim.keymap.set('n', '<leader>n', '<cmd> NvimTreeFocus <CR>', { desc = 'Focus nvim-tree' })
  end,
  opts = {
    git = {
      enable = true,
    },
    filters = {
      custom = {
        '^.git$',
        '^.null-ls_',
      },
    },
    on_attach = function(bufnr)
      local api = require 'nvim-tree.api'

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', '=', api.node.open.edit, opts 'Open')
      vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts 'Open: Vertical Split')
      vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts 'Open: Horizontal Split')
    end,
  },
}
