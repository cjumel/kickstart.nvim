-- telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

return {
  "nvim-telescope/telescope.nvim",
  -- TODO: it is not recommanded to use the master branch, but it is necessary for the filter_fn
  -- option of the command_history function; uncomment the following line when it's not necessary
  -- anymore:
  -- branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-treesitter/nvim-treesitter",
    "folke/trouble.nvim",
  },
  keys = {
    -- General
    {
      "<leader>F",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "[F]ind: resume",
    },
    {
      "S",
      function()
        local opts = require("plugins.navigation.telescope.utils.themes").get_dropdown()
        require("telescope.builtin").current_buffer_fuzzy_find(opts)
      end,
      desc = "[S]earch fuzzily",
    },

    -- Find files by name
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          find_command = { "rg", "--files", "--hidden" },
          preview = { hide_on_startup = true },
        })
      end,
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({
          find_command = { "rg", "--files", "--hidden" },
          follow = true,
          no_ignore = true,
          preview = { hide_on_startup = true },
        })
      end,
      desc = "[F]ind: [A]ll files",
    },
    {
      "<leader>fo",
      function()
        require("telescope.builtin").oldfiles({
          initial_mode = "normal",
          preview = { hide_on_startup = true },
        })
      end,
      desc = "[F]ind: [O]ld files",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").git_status({
          initial_mode = "normal",
          -- <tab> is used to stage in this picker so we can't enable the preview after startup
          preview = { hide_on_startup = false },
        })
      end,
      desc = "[F]ind: Git [S]tatus files",
    },

    -- Find files by content
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "[F]ind: by [G]rep",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string({ initial_mode = "normal" })
      end,
      mode = { "n", "v" },
      desc = "[F]ind: [W]ord under the cursor",
    },

    -- Vim- or Neovim-related
    {
      "<leader><tab>",
      function()
        local opts = require("plugins.navigation.telescope.utils.themes").get_dropdown()
        opts.initial_mode = "normal"
        opts.only_cwd = true
        opts.sort_lastused = true
        opts.sort_mru = true
        require("telescope.builtin").buffers(opts)
      end,
      desc = "Buffer switcher",
    },
    {
      "<leader><leader>",
      function()
        local opts = require("plugins.navigation.telescope.utils.themes").get_commands_dropdown()
        require("telescope.builtin").commands(opts)
      end,
      desc = "Find fuzzily in commands",
    },
    {
      "<leader>:",
      function()
        local opts = require("plugins.navigation.telescope.utils.themes").get_dropdown("normal")
        opts.filter_fn =
          require("plugins.navigation.telescope.utils.filters").command_history_filter_fn
        require("telescope.builtin").command_history(opts)
      end,
      desc = "Find fuzzily in command history",
    },
    {
      "<leader>/",
      function()
        local opts = require("plugins.navigation.telescope.utils.themes").get_dropdown("normal")
        require("telescope.builtin").search_history(opts)
      end,
      desc = "Find fuzzily in search history",
    },

    -- Help-related
    {
      "<leader>fk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "[F]ind: [K]eymaps",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "[F]ind: [H]elp tags",
    },
  },
  config = function()
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")
    local trouble = require("trouble.providers.telescope")
    require("telescope").setup({
      defaults = {
        default_mappings = {
          i = {
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-t>"] = trouble.open_with_trouble,

            ["<tab>"] = actions_layout.toggle_preview,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            -- disable c-j because we dont want to allow new lines #2123
            ["<C-j>"] = actions.nop,
          },

          n = {
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-t>"] = trouble.open_with_trouble,

            ["<tab>"] = actions_layout.toggle_preview,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["v"] = actions.toggle_selection,

            ["<esc>"] = actions.close,
            ["?"] = actions.which_key,
          },
        },
        -- vimgrep_arguments is used for live_grep and grep_string
        vimgrep_arguments = {
          "rg",
          "--color=never", -- must not be removed
          "--no-heading", -- must not be removed
          "--with-filename", -- must not be removed
          "--line-number", -- must not be removed
          "--column", -- must not be removed
          "--smart-case",
          "--hidden",
        },
        file_ignore_patterns = {
          ".git/",
        },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            preview_width = 0.5,
            prompt_position = "top",
            width = 0.9,
          },
          vertical = {
            prompt_position = "top",
            mirror = true,
          },
        },
        path_display = function(opts, path)
          -- Apply builtin path display options
          local path_display_opts = {
            truncate = 1, -- truncate and leave some space with the border
          }
          local transform_path = require("telescope.utils").transform_path
          path = transform_path({ path_display = path_display_opts }, path)

          -- Replace home directory with ~
          path = string.gsub(path, "/Users/clement", "~")

          return path
        end,
      },
      pickers = {
        buffers = {
          mappings = {
            n = {
              ["d"] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
  end,
}
