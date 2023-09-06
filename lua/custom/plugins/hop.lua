-- Hop
--
-- Hop is a plugin enabling fast in-file navigation.

vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('hop').hint_char2()
end, { desc = 'Jump to a combinaison of 2 keys' })
vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
  require('hop').hint_char1 {
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = true,
  }
end, { desc = 'Jump to a following key inline' })
vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
  require('hop').hint_char1 {
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = true,
  }
end, { desc = 'Jump to a preceding key inline' })
vim.keymap.set({ 'n', 'x', 'o' }, 't', function()
  require('hop').hint_char1 {
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = true,
    hint_offset = -1,
  }
end, { desc = 'Jump to before a following key inline' })
vim.keymap.set({ 'n', 'x', 'o' }, 'T', function()
  require('hop').hint_char1 {
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = true,
    hint_offset = 1,
  }
end, { desc = 'Jump to after a preceding key inline' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>w', function()
  require('hop').hint_words {
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = true,
  }
end, { desc = 'Jump to a following word beginning inline' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>b', function()
  require('hop').hint_words {
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = true,
  }
end, { desc = 'Jump to a preceding word beginning inline' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>e', function()
  require('hop').hint_words {
    hint_position = require('hop.hint').HintPosition.END,
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = true,
  }
end, { desc = 'Jump to a following word end inline' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>ge', function()
  require('hop').hint_words {
    hint_position = require('hop.hint').HintPosition.END,
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = true,
  }
end, { desc = 'Jump to a preceding word end inline' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>j', function()
  require('hop').hint_lines {
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
  }
end, { desc = 'Jump to a following line' })
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>k', function()
  require('hop').hint_lines {
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
  }
end, { desc = 'Jump to a preceding line' })

return {
  'phaazon/hop.nvim',
  lazy = true,
  opts = {
    keys = 'hgjfkdlsmqyturieozpabvn',
    uppercase_labels = true,
  },
}
