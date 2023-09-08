-- Telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  lazy = true,
  init = function()
    vim.keymap.set('n', '<leader>fo', function()
      require('telescope.builtin').oldfiles()
    end, { desc = '[F]ind [O]ld Files' })
    vim.keymap.set('n', '<leader><space>', function()
      require('telescope.builtin').buffers()
    end, { desc = '[ ] Find Buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily Search in Buffer' })

    vim.keymap.set('n', '<leader>ff', function()
      require('telescope.builtin').find_files {
        find_command = { 'rg', '--files', '--hidden' },
      }
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fh', function()
      require('telescope.builtin').help_tags()
    end, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fw', function()
      require('telescope.builtin').grep_string()
    end, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>fg', function()
      require('telescope.builtin').live_grep()
    end, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fd', function()
      require('telescope.builtin').diagnostics()
    end, { desc = '[F]ind [D]iagnostics' })
  end,
  config = function()
    local actions = require 'telescope.actions'
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-s>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
          },
          n = {
            ['='] = actions.select_default,
            ['<C-s>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['g?'] = actions.which_key,
          },
        },
        -- vimgrep_arguments is used for live_grep and grep_string
        vimgrep_arguments = {
          'rg',
          '--color=never', -- must not be removed
          '--no-heading', -- must not be removed
          '--with-filename', -- must not be removed
          '--line-number', -- must not be removed
          '--column', -- must not be removed
          '--smart-case',
          '--hidden',
        },
        file_ignore_patterns = {
          '.git/',
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
  end,
}
