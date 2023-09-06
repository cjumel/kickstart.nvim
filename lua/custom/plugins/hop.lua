-- Hop
--
-- Hop is a plugin enabling fast in-file navigation.

return {
  'phaazon/hop.nvim',
  lazy = true,
  opts = {
    keys = 'hgjfkdlsmqyturieozpabvn',
    uppercase_labels = true,
  },
  init = function()
    vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
      require('hop').hint_char2()
    end, { desc = '[S]earch 2 keys with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
      require('hop').hint_char1 {
        direction = require('hop.hint').HintDirection.AFTER_CURSOR,
        current_line_only = true,
      }
    end, { desc = '[f] vim key with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
      require('hop').hint_char1 {
        direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
        current_line_only = true,
      }
    end, { desc = '[F] vim key with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', function()
      require('hop').hint_char1 {
        direction = require('hop.hint').HintDirection.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1,
      }
    end, { desc = '[t] vim key with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', function()
      require('hop').hint_char1 {
        direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = 1,
      }
    end, { desc = '[T] vim key with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>w', function()
      require('hop').hint_words {
        direction = require('hop.hint').HintDirection.AFTER_CURSOR,
        current_line_only = true,
      }
    end, { desc = '[w] vim key with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>b', function()
      require('hop').hint_words {
        direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
        current_line_only = true,
      }
    end, { desc = '[b] vim key with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>e', function()
      require('hop').hint_words {
        hint_position = require('hop.hint').HintPosition.END,
        direction = require('hop.hint').HintDirection.AFTER_CURSOR,
        current_line_only = true,
      }
    end, { desc = '[e] vim key with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>ge', function()
      require('hop').hint_words {
        hint_position = require('hop.hint').HintPosition.END,
        direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
        current_line_only = true,
      }
    end, { desc = '[ge] vim keys with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>j', function()
      require('hop').hint_lines {
        direction = require('hop.hint').HintDirection.AFTER_CURSOR,
      }
    end, { desc = '[j] vim key with Hop' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<leader>k', function()
      require('hop').hint_lines {
        direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
      }
    end, { desc = '[k] vim key with Hop' })
  end,
}
