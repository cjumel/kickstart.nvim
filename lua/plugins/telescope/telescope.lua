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
        local opts = require("plugins.telescope.utils.themes").get_small_dropdown()
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

    -- Git-related
    {
      "<leader>gf",
      function()
        local opts = require("plugins.telescope.utils.themes").get_large_dropdown("normal")
        require("telescope.builtin").git_status(opts)
      end,
      desc = "[G]it: [F]ind modified files",
    },
    {
      "<leader>gb",
      function()
        local opts = require("plugins.telescope.utils.themes").get_large_dropdown()
        require("telescope.builtin").git_branches(opts)
      end,
      desc = "[G]it: [B]ranches",
    },
    {
      "<leader>gl",
      function()
        local opts = require("plugins.telescope.utils.themes").get_large_dropdown("normal")
        require("telescope.builtin").git_commits(opts)
      end,
      desc = "[G]it: [L]og",
    },

    -- Vim- or Neovim-related
    {
      "<leader><tab>",
      function()
        local opts = require("plugins.telescope.utils.themes").get_small_dropdown()
        opts.initial_mode = "normal"
        opts.only_cwd = true
        opts.sort_lastused = true
        opts.sort_mru = true
        require("telescope.builtin").buffers(opts)
      end,
      desc = "[  ] Buffer switcher",
    },
    {
      "<leader><leader>",
      function()
        local opts = require("plugins.telescope.utils.themes").get_commands_dropdown()
        require("telescope.builtin").commands(opts)
      end,
      desc = "[ ] Find fuzzily in commands",
    },
    {
      "<leader>:",
      function()
        local opts = require("plugins.telescope.utils.themes").get_small_dropdown("normal")
        opts.filter_fn = require("plugins.telescope.utils.filters").command_history_filter_fn
        require("telescope.builtin").command_history(opts)
      end,
      desc = "[:] Find fuzzily in command history",
    },
    {
      "<leader>/",
      function()
        local opts = require("plugins.telescope.utils.themes").get_small_dropdown("normal")
        require("telescope.builtin").search_history(opts)
      end,
      desc = "[/] Find fuzzily in search history",
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
  init = function()
    vim.api.nvim_create_user_command("GitStashList", function()
      local opts = require("plugins.telescope.utils.themes").get_large_dropdown("normal")
      require("telescope.builtin").git_stash(opts)
    end, { desc = "Git stash list" })
  end,
  config = function()
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")
    local trouble = require("trouble.providers.telescope")
    require("telescope").setup({
      defaults = {
        mappings = {
          n = {
            ["<tab>"] = actions_layout.toggle_preview,
            ["="] = actions.select_default,
            ["q"] = actions.close,
            ["<c-t>"] = trouble.open_with_trouble,
          },
          i = {
            ["<tab>"] = actions_layout.toggle_preview,
            ["<c-t>"] = trouble.open_with_trouble,
          },
        },
        default_mappings = {
          i = {
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,

            ["<C-c>"] = actions.close,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-f>"] = actions.preview_scrolling_left,
            ["<C-k>"] = actions.preview_scrolling_right,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<M-f>"] = actions.results_scrolling_left,
            ["<M-k>"] = actions.results_scrolling_right,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-/>"] = actions.which_key,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            ["<C-w>"] = { "<c-s-w>", type = "command" },

            -- disable c-j because we dont want to allow new lines #2123
            ["<C-j>"] = actions.nop,
          },

          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            -- TODO: This would be weird if we switch the ordering.
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

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
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
  end,
}
