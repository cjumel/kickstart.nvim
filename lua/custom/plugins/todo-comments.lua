-- todo-comments
--
-- Enable highlighting for TODO comments, but also, FIXME, BUG, and others.
-- Additionally, provide commands to list and access them.

vim.keymap.set('n', '<leader>td', '<cmd> TodoQuickFix <CR>', { desc = 'Display TODO comments in quickfix tab' })

return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  opts = {
    search = {
      args = {
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--hidden',
        '--glob=!.git/',
      },
    },
  },
}
