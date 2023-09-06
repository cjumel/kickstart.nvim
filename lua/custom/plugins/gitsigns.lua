-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua.

-- TODO: try:
-- map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
-- map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
-- map('n', '<leader>hu', gs.undo_stage_hunk)
-- map('n', '<leader>td', gs.toggle_deleted)

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
