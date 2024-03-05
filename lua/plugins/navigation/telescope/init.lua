-- telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

local custom_actions = require("plugins.navigation.telescope.actions")
local custom_opts = require("plugins.navigation.telescope.opts")

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
        require("telescope.builtin").resume({
          -- When resuming Telescope, a search has already been done, so it makes more sens to
          -- resume in normal mode (it's also easier to resume navigation in previous searches
          -- that way)
          initial_mode = "normal",
        })
      end,
      desc = "Resume Telescope",
    },

    -- Find files by name
    {
      "<leader>ff",
      function()
        local opts = {
          find_command = { "fd", "--type", "f", "--color", "never" }, -- Default fd command
          preview = { hide_on_startup = true },
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").find_files(opts)
      end,
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fh",
      function()
        local opts = {
          find_command = { -- Default fd command with hidden files
            "fd",
            "--type",
            "f",
            "--color",
            "never",
            "--hidden",
            "--exclude",
            ".git",
          },
          preview = { hide_on_startup = true },
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").find_files(opts)
      end,
      desc = "[F]ind: files incl. [H]idden",
    },
    {
      "<leader>fa",
      function()
        local opts = {
          find_command = { -- Default fd command with hidden & ignored files
            "fd",
            "--type",
            "f",
            "--color",
            "never",
            "--hidden",
            "--exclude",
            ".git",
            "--no-ignore",
          },
          preview = { hide_on_startup = true },
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").find_files(opts)
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
        local opts = {}
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").live_grep(opts)
      end,
      desc = "[F]ind: by [G]rep",
    },
    {
      "<leader>fG",
      function()
        local opts = {
          additional_args = { "-uu" },
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").live_grep(opts)
      end,
      desc = "[F]ind: by [G]rep (unrestricted)",
    },
    {
      "<leader>fw",
      function()
        local opts = {
          -- The string has already been searched so it makes more sens to start in normal mode
          initial_mode = "normal",
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").grep_string(opts)
      end,
      desc = "[F]ind: [W]ord",
    },
    {
      "<leader>f",
      function()
        local opts = {
          -- The string has already been searched so it makes more sens to start in normal mode
          initial_mode = "normal",
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").grep_string(opts)
      end,
      mode = { "v" },
      desc = "[F]ind selection",
    },
    {
      "<leader>fW",
      function()
        local opts = {
          -- The string has already been searched so it makes more sens to start in normal mode
          initial_mode = "normal",
          additional_args = { "-uu" },
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").grep_string(opts)
      end,
      desc = "[F]ind: [W]ord (unrestricted)",
    },
    {
      "<leader>F",
      function()
        local opts = {
          -- The string has already been searched so it makes more sens to start in normal mode
          initial_mode = "normal",
          additional_args = { "-uu" },
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").grep_string(opts)
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
    {
      "<leader>;",
      function()
        require("telescope.builtin").jumplist({
          initial_mode = "normal",
          tiebreak = custom_opts.recency_tiebreak,
        })
      end,
      desc = "Jump list",
    },

    -- Git related
    {
      "<leader>gs",
      function()
        require("telescope.builtin").git_status({ initial_mode = "normal" })
      end,
      desc = "[G]it: [S]tatus",
    },
    {
      "<leader>gb",
      function()
        require("telescope.builtin").git_branches({ initial_mode = "normal" })
      end,
      desc = "[G]it: [B]ranches",
    },
    {
      "<leader>gl",
      function()
        require("telescope.builtin").git_commits({ initial_mode = "normal" })
      end,
      desc = "[G]it: [L]og",
    },
    {
      "<leader>gL",
      function()
        require("telescope.builtin").git_bcommits({ initial_mode = "normal" })
      end,
      desc = "[G]it: buffer [L]og",
    },
    {
      "<leader>g",
      function()
        require("telescope.builtin").git_bcommits_range({ initial_mode = "normal" })
      end,
      mode = "v",
      desc = "[G]it: log for selection",
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
    local actions_generate = require("telescope.actions.generate")
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

            ["<C-q>"] = custom_actions.smart_send_to_qflist,
            ["<C-l>"] = custom_actions.smart_send_to_loclist,
            ["<C-t>"] = custom_actions.smart_open_with_trouble,

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
            ["s"] = actions.toggle_selection + actions.move_selection_next,

            ["<TAB>"] = layout_actions.toggle_preview,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-f>"] = actions.preview_scrolling_right,
            ["<C-b>"] = actions.preview_scrolling_left,

            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,

            ["<C-q>"] = custom_actions.smart_send_to_qflist,
            ["<C-l>"] = custom_actions.smart_send_to_loclist,
            ["<C-t>"] = custom_actions.smart_open_with_trouble,

            ["?"] = actions_generate.which_key({
              only_show_current_mode = false,
            }),

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
