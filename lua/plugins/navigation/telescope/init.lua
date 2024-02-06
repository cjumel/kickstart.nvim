-- telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

local custom_opts = require("plugins.navigation.telescope.opts")

local custom_actions = {}

-- Define custom actions for Trouble to make it lazy-loaded
custom_actions.open_with_trouble = function(prompt_bufnr, _mode)
  local trouble_actions = require("trouble.providers.telescope")
  trouble_actions.open_with_trouble(prompt_bufnr, _mode)
end
custom_actions.open_selected_with_trouble = function(prompt_bufnr, _mode)
  local trouble_actions = require("trouble.providers.telescope")
  trouble_actions.open_selected_with_trouble(prompt_bufnr, _mode)
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume Telescope",
    },

    -- Find files by name
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files(custom_opts.find_files)
      end,
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").find_files(custom_opts.find_files_hidden)
      end,
      desc = "[F]ind: files incl. [H]idden",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files(custom_opts.find_files_all)
      end,
      desc = "[F]ind: [A]ll files",
    },
    {
      "<leader>fo",
      function()
        require("telescope.builtin").oldfiles({
          preview = { hide_on_startup = true },
          tiebreak = custom_opts.recency_tiebreak,
        })
      end,
      desc = "[F]ind: [O]ld files",
    },

    -- Find by content
    {
      "<leader>fz",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "[F]ind: fu[Z]zily in buffer",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep(custom_opts.live_grep)
      end,
      desc = "[F]ind: by [G]rep",
    },
    {
      "<leader>fG",
      function()
        require("telescope.builtin").live_grep(custom_opts.live_grep_unrestricted)
      end,
      desc = "[F]ind: by [G]rep (unrestricted)",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string(custom_opts.grep_string)
      end,
      desc = "[F]ind: [W]ord",
    },
    {
      "<leader>f",
      function()
        require("telescope.builtin").grep_string(custom_opts.grep_string)
      end,
      mode = { "v" },
      desc = "[F]ind selection",
    },
    {
      "<leader>fW",
      function()
        require("telescope.builtin").grep_string(custom_opts.grep_string_unrestricted)
      end,
      desc = "[F]ind: [W]ord (unrestricted)",
    },
    {
      "<leader>F",
      function()
        require("telescope.builtin").grep_string(custom_opts.grep_string_unrestricted)
      end,
      mode = { "v" },
      desc = "[F]ind selection (unrestricted)",
    },

    -- Vim- or Neovim-related
    {
      "<leader>:",
      function()
        local opts = require("telescope.themes").get_dropdown(custom_opts.dropdown)
        opts.filter_fn = custom_opts.command_history_filter_fn
        opts.tiebreak = custom_opts.recency_tiebreak
        require("telescope.builtin").command_history(opts)
      end,
      desc = "Command history",
    },
    {
      "<leader>/",
      function()
        local opts = require("telescope.themes").get_dropdown(custom_opts.dropdown)
        opts.tiebreak = custom_opts.recency_tiebreak
        require("telescope.builtin").search_history(opts)
      end,
      desc = "Search history",
    },

    -- Git related
    {
      "<leader>gs",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "[G]it: [S]tatus",
    },
    {
      "<leader>gb",
      function()
        require("telescope.builtin").git_branches()
      end,
      desc = "[G]it: [B]ranches",
    },
    {
      "<leader>gl",
      function()
        require("telescope.builtin").git_commits()
      end,
      desc = "[G]it: [L]og",
    },

    -- Help related
    {
      "<leader>?c",
      function()
        require("telescope.builtin").commands()
      end,
      desc = "Help: [C]ommands",
    },
    {
      "<leader>?k",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Help: [K]eymaps",
    },
    {
      "<leader>?h",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help: [H]elp tags",
    },
  },
  config = function()
    local actions = require("telescope.actions")
    local layout_actions = require("telescope.actions.layout")

    require("telescope").setup({
      defaults = {
        default_mappings = {
          i = {
            ["<CR>"] = actions.select_default,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,

            ["<TAB>"] = layout_actions.toggle_preview,

            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,

            ["<C-t>"] = custom_actions.open_with_trouble,

            ["<C-\\>"] = actions.which_key, -- Actually <C-m> on my setup, like "mappings"

            ["<C-c>"] = actions.close,
          },

          n = {
            ["<CR>"] = actions.select_default,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["G"] = actions.move_to_bottom,
            ["gg"] = actions.move_to_top,

            ["<TAB>"] = layout_actions.toggle_preview,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-f>"] = actions.preview_scrolling_right,
            ["<C-b>"] = actions.preview_scrolling_left,

            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,

            ["v"] = actions.toggle_selection,

            ["<C-t>"] = custom_actions.open_with_trouble,
            ["t"] = custom_actions.open_selected_with_trouble,

            ["<C-\\>"] = actions.which_key, -- Actually <C-m> on my setup, like "mappings"
            ["?"] = actions.which_key,

            ["<C-c>"] = actions.close,
            ["<ESC>"] = actions.close,
          },
        },
        vimgrep_arguments = { -- for live_grep and grep_string pickers
          -- mandatory arguments
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          -- optional arguments
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
        path_display = function(_, path)
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
