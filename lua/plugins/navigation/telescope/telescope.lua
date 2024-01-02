-- telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

local command_history_filter_fn = function(cmd)
  -- Discard commands like "w", "q", "wq", "wqa", etc.
  if string.len(cmd) < 4 then
    return false
  end
  return true
end

-- Code taken from https://gist.github.com/benlubas/09254459af633cce1b5ac12d16640f0e
local add_harpoon_mark_from_telescope = function(tb)
  local telescope_utils = require("telescope.actions.utils")
  local actions = require("telescope.actions")

  actions.drop_all(tb)
  actions.add_selection(tb)
  telescope_utils.map_selections(tb, function(selection)
    local file = selection[1]

    -- Handle special pickers
    if selection.filename then -- For live_grep picker
      file = selection.filename
    elseif selection.value then -- For git_status picker
      file = selection.value
    end

    require("plugins.navigation.harpoon.utils.actions").add_mark(file)
  end)
  actions.remove_selection(tb)
end

return {
  "nvim-telescope/telescope.nvim",
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
        require("telescope.builtin").find_files({
          find_command = {
            -- Default command for fd in telescope implementation
            "fd",
            "--type",
            "f",
            "--color",
            "never",
          },
          preview = { hide_on_startup = true },
        })
      end,
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({
          find_command = {
            -- Default command for fd in telescope implementation
            "fd",
            "--type",
            "f",
            "--color",
            "never",
            -- Additional arguments
            "--hidden",
            "--exclude",
            ".git",
          },
          preview = { hide_on_startup = true },
        })
      end,
      desc = "[F]ind: [A]ll files",
    },
    {
      "<leader>fo",
      function()
        require("telescope.builtin").oldfiles({
          preview = { hide_on_startup = true },
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
      desc = "[F]ind: fu[Z]zily in current buffer",
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
        require("telescope.builtin").grep_string()
      end,
      mode = { "n", "v" },
      desc = "[F]ind: [W]ord under the cursor",
    },

    -- Vim- or Neovim-related
    {
      "<leader>:",
      function()
        local opts = require("plugins.navigation.telescope.utils.themes").get_dropdown()
        opts.filter_fn = command_history_filter_fn
        require("telescope.builtin").command_history(opts)
      end,
      desc = "Command history",
    },
    {
      "<leader>/",
      function()
        local opts = require("plugins.navigation.telescope.utils.themes").get_dropdown()
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
      "<leader>,k",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Settings: [K]eymaps",
    },
    {
      "<leader>,h",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Settings: [H]elp tags",
    },
  },
  config = function()
    local actions = require("telescope.actions")
    local layout_actions = require("telescope.actions.layout")
    local trouble_actions = require("trouble.providers.telescope")

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
            ["<C-t>"] = trouble_actions.open_with_trouble,

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
            ["<C-t>"] = trouble_actions.open_with_trouble,
            ["v"] = actions.toggle_selection,
            ["t"] = trouble_actions.open_selected_with_trouble,
            ["<leader><CR>"] = add_harpoon_mark_from_telescope,

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
