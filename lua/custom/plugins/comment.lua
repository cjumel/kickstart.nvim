-- comment.nvim
--
-- Define many keymaps to comment code, using `gc` and others.

return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  opts = {},
  init = function()
    vim.keymap.set('n', 'gtc', function()
      vim.api.nvim_command 'normal! ITODO: '
      require('Comment.api').toggle.linewise.current()
      vim.api.nvim_command 'normal! 3l'
    end, { desc = '[g]c[c] for [T]odo-comments' })

    -- FIXME: this is not working when the current line is a comment
    vim.keymap.set('n', 'gto', function()
      vim.api.nvim_command 'normal! oTODO: '
      require('Comment.api').toggle.linewise.current()
      vim.api.nvim_command 'normal! 3l'
    end, { desc = '[g]c[o] for [T]odo-comments' })

    -- FIXME: this is not working when the current line is a comment
    vim.keymap.set('n', 'gtO', function()
      vim.api.nvim_command 'normal! OTODO: '
      require('Comment.api').toggle.linewise()
      vim.api.nvim_command 'normal! 3l'
    end, { desc = '[g]c[O] for [T]odo-comments' })
  end,
}
