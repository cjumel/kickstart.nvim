-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua.

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '[h', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[[] Next [H]unk' })
      vim.keymap.set('n', ']h', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[]] Previous [H]unk' })
      vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      vim.keymap.set('n', '<leader>rh', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[R]eset [H]unk' })
      vim.keymap.set('n', '<leader>rb', require('gitsigns').reset_buffer, { buffer = bufnr, desc = '[R]eset [B]uffer' })
      vim.keymap.set('n', '<leader>sh', require('gitsigns').stage_hunk, { buffer = bufnr, desc = '[S]tage [H]unk' })
      vim.keymap.set('n', '<leader>sb', require('gitsigns').stage_buffer, { buffer = bufnr, desc = '[S]tage [B]uffer' })
    end,
  },
}
