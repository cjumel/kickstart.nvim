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
    'folke/trouble.nvim',
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
    vim.keymap.set('n', '<leader><space>', function()
      require('telescope.builtin').buffers()
    end, { desc = '[ ] Find Buffers' })

    vim.keymap.set('n', '<leader>/', function()
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily Search in Buffer' })

    vim.keymap.set('n', '<leader>fr', function()
      require('telescope.builtin').resume()
    end, { desc = '[F]ind [R]resume' })

    -- Find files by file name
    vim.keymap.set('n', '<leader>ff', function()
      require('telescope.builtin').find_files {
        find_command = { 'rg', '--files', '--hidden' },
      }
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fa', function()
      require('telescope.builtin').find_files {
        find_command = { 'rg', '--files', '--hidden' },
        follow = true,
        no_ignore = true,
      }
    end, { desc = '[F]ind [A]ll Files' })
    vim.keymap.set('n', '<leader>fo', function()
      require('telescope.builtin').oldfiles()
    end, { desc = '[F]ind [O]ld Files' })

    -- Find files by file content
    vim.keymap.set('n', '<leader>fg', function()
      require('telescope.builtin').live_grep()
    end, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fw', function()
      require('telescope.builtin').grep_string()
    end, { desc = '[F]ind Current [W]ord' })

    -- Git-related find commands
    vim.keymap.set('n', '<leader>fs', function()
      require('telescope.builtin').git_status()
    end, { desc = '[F]ind Git [S]tatus' })
    vim.keymap.set('n', '<leader>fcm', function()
      require('telescope.builtin').git_commits()
    end, { desc = '[F]ind Git [C]o[m]mits' })
    vim.keymap.set('n', '<leader>fS', function()
      require('telescope.builtin').git_stash()
    end, { desc = '[F]ind Git [S]tash' })

    -- Neovim-related find commands
    vim.keymap.set('n', '<leader>fk', function()
      require('telescope.builtin').keymaps()
    end, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>fcu', function()
      require('telescope.builtin').commands()
    end, { desc = '[F]ind [C]ommand [U]sage' })
    vim.keymap.set('n', '<leader>fch', function()
      require('telescope.builtin').command_history()
    end, { desc = '[F]ind [C]ommand [H]istory' })
    vim.keymap.set('n', '<leader>fh', function()
      require('telescope.builtin').help_tags()
    end, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fcs', function()
      require('telescope.builtin').colorscheme()
    end, { desc = '[F]ind [C]olor[S]cheme' })
  end,
  config = function()
    local actions = require 'telescope.actions'
    local trouble = require 'trouble.providers.telescope'
    require('telescope').setup {
      defaults = {
        n = {
          ['='] = actions.select_default,
          ['<c-t>'] = trouble.open_with_trouble,
        },
        mappings = {
          i = {
            ['<c-t>'] = trouble.open_with_trouble,
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
