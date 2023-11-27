-- telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

return {
  "nvim-telescope/telescope.nvim",
  -- NOTE:
  -- It is not recommanded to use the master branch, but it is necessary for the filter_fn
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
      "S", -- Builtin `S` is equivalent to `cc` & is not super usefull
      function()
        local opts = require("plugins.navigation.telescope.custom.themes").get_dropdown()
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
        local opts = require("plugins.navigation.telescope.custom.themes").get_dropdown("normal")
        require("telescope.builtin").oldfiles(opts)
      end,
      desc = "[F]ind: [O]ld files",
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
      "<leader><leader>",
      function()
        local opts = require("plugins.navigation.telescope.custom.themes").get_dropdown("normal")
        opts.only_cwd = true
        opts.sort_lastused = true
        opts.sort_mru = true
        require("telescope.builtin").buffers(opts)
      end,
      desc = "Buffer switcher",
    },
    {
      "<leader>:",
      function()
        local opts = require("plugins.navigation.telescope.custom.themes").get_dropdown("normal")
        opts.filter_fn =
          require("plugins.navigation.telescope.custom.filters").command_history_filter_fn
        require("telescope.builtin").command_history(opts)
      end,
      desc = "Find fuzzily in command history",
    },
    {
      "<leader>/",
      function()
        local opts = require("plugins.navigation.telescope.custom.themes").get_dropdown("normal")
        require("telescope.builtin").search_history(opts)
      end,
      desc = "Find fuzzily in search history",
    },

    -- Git related
    {
      "<leader>fs",
      function()
        local opts = require("plugins.navigation.telescope.custom.themes").get_dropdown("normal")
        require("telescope.builtin").git_status(opts)
      end,
      desc = "[F]ind: Git [S]tatus files",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").git_branches({
          layout_strategy = "vertical",
          initial_mode = "normal",
        })
      end,
      desc = "[F]ind: Git [B]ranches",
    },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").git_commits({
          layout_strategy = "vertical",
          initial_mode = "normal",
        })
      end,
      desc = "[F]ind: Git [C]ommits",
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
    local layout_actions = require("telescope.actions.layout")
    local trouble_actions = require("trouble.providers.telescope")
    local custom_actions = require("plugins.navigation.telescope.custom.actions")

    require("telescope").setup({
      defaults = {
        default_mappings = {
          i = {
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-t>"] = trouble_actions.open_with_trouble,

            ["<tab>"] = layout_actions.toggle_preview,

            -- Prevent conflicts with insert mode terminal-like keymaps
            ["<C-u>"] = false,
            ["<C-d>"] = false,
            ["<C-b>"] = false,
            ["<C-f>"] = false,

            -- disable c-j because we dont want to allow new lines #2123
            ["<C-j>"] = actions.nop,
          },

          n = {
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-t>"] = trouble_actions.open_with_trouble,

            ["<tab>"] = layout_actions.toggle_preview,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["v"] = actions.toggle_selection,
            ["Q"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["T"] = trouble_actions.open_selected_with_trouble,
            ["<leader><CR>"] = custom_actions.add_harpoon_mark_from_telescope,

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
            preview_cutoff = 50,
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
        -- Override the <tab> key in git_status for the preview instead of staging the file
        git_status = {
          mappings = {
            i = {
              ["<tab>"] = layout_actions.toggle_preview,
            },
            n = {
              ["<tab>"] = layout_actions.toggle_preview,
            },
          },
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
  end,
}
