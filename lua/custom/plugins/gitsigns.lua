-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua, which make it and fugitive
-- perfect for a complete git integration.

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
      -- Use keymaps very similar to gitsigns and kickstart defaults

      -- Navigation
      vim.keymap.set({ 'n', 'v' }, '[h', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          require('gitsigns').next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = '[[] Next Git [H]unk' })
      vim.keymap.set({ 'n', 'v' }, ']h', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          require('gitsigns').prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = '[]] Previous Git [H]unk' })

      -- Actions
      vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Git [H]unk: [P]review' })
      vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { buffer = bufnr, desc = 'Git [H]unk: [S]tage' })
      vim.keymap.set('v', '<leader>hs', function()
        require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { buffer = bufnr, desc = 'Git [H]unk: [S]tage' })
      vim.keymap.set('n', '<leader>hS', require('gitsigns').stage_buffer, { buffer = bufnr, desc = 'Git [H]unk: [S]tage All' })
      vim.keymap.set('n', '<leader>hu', require('gitsigns').undo_stage_hunk, { buffer = bufnr, desc = 'Git [H]unk: [U]ndo Stage' })
      vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = 'Git [H]unk: [R]eset' })
      vim.keymap.set('v', '<leader>hr', function()
        require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { buffer = bufnr, desc = 'Git [H]unk: [R]eset' })
      vim.keymap.set('n', '<leader>hR', require('gitsigns').reset_buffer, { buffer = bufnr, desc = 'Git [H]unk: [R]eset All' })
      vim.keymap.set('n', '<leader>hd', require('gitsigns').toggle_deleted, { buffer = bufnr, desc = 'Git [H]unk: Toggle [D]eleted' })

      -- Text object
      vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr, desc = 'inner git hunk' })
      vim.keymap.set({ 'o', 'x' }, 'ah', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr, desc = 'a git hunk' })
    end,
  },
}
