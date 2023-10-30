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
    {
      "<leader><tab>",
      function()
        local opts = require("plugins.telescope.utils.themes").get_small_dropdown()
        opts.previewer = false
        opts.initial_mode = "normal"
        opts.ignore_current_buffer = true
        opts.only_cwd = true
        opts.sort_mru = true
        require("telescope.builtin").buffers(opts)
      end,
      desc = "[  ] Buffer switcher",
    },

    -- Find files
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
      "<leader>fc",
      function()
        require("telescope.builtin").git_status({ initial_mode = "normal" })
      end,
      desc = "[F]ind: [C]hanged files",
    },
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
