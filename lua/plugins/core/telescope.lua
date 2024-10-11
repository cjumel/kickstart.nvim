-- telescope.nvim
--
-- telescope.nvim is a plugin which enables to gaze deeply into unknown regions of your code with powerful and blazing
-- fast fuzzy finding tools. It is one of the most essential plugins I use. It provides a really versatile interface,
-- suited for many use-cases beyond fuzzy-finding files, like LSP reference navigation, or user input selection.
-- Besides, it is very easily customizable, easier by crafting complex options or by creating extensions.

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
    {
      "nvim-telescope/telescope-fzf-native.nvim", -- Fuzzy finder algorithm requiring local dependencies to be built
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end, -- Only load if make is available
    },
  },
  cmd = { "Telescope" }, -- Especially useful for other plugins calling Telescope through a command
  keys = {
    -- Main finders
    {
      "<leader>ff",
      function() require("plugins.core.telescope.builtin").find_files() end,
      mode = { "n", "v" },
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fd",
      function() require("plugins.core.telescope.builtin").find_directories() end,
      mode = { "n", "v" },
      desc = "[F]ind: [D]irectories",
    },
    {
      "<leader>fg",
      function() require("plugins.core.telescope.builtin").live_grep() end,
      mode = { "n", "v" },
      desc = "[F]ind: by [G]rep",
    },
    {
      "<leader>fo",
      function() require("plugins.core.telescope.builtin").oldfiles() end,
      mode = { "n", "v" },
      desc = "[F]ind: [O]ldfiles",
    },
    {
      "<leader>fb",
      function() require("plugins.core.telescope.builtin").current_buffer_fuzzy_find() end,
      mode = { "n", "v" },
      desc = "[F]ind: in [B]uffer",
    },
    {
      "<leader>fm",
      function() require("plugins.core.telescope.builtin").man_pages() end,
      mode = { "n", "v" },
      desc = "[F]ind: [M]an pages",
    },

    -- Neovim-related
    {
      "<leader><Tab>",
      function() require("plugins.core.telescope.builtin").buffers() end,
      desc = "Buffer switcher",
    },
    {
      "<leader>;",
      function() require("plugins.core.telescope.builtin").resume() end,
      desc = "Resume Telescope",
    },
    {
      "<leader>:",
      function() require("plugins.core.telescope.builtin").command_history() end,
      desc = "Command history",
    },
    {
      "<leader>/",
      function() require("plugins.core.telescope.builtin").search_history() end,
      desc = "Search history",
    },
    {
      "<leader>fc",
      function() require("plugins.core.telescope.builtin").commands() end,
      mode = { "n", "v" },
      desc = "[F]ind: [C]ommands",
    },
    {
      "<leader>fh",
      function() require("plugins.core.telescope.builtin").help_tags() end,
      mode = { "n", "v" },
      desc = "[F]ind: [H]elp tags",
    },

    -- Git related
    {
      "<leader>gg",
      function() require("plugins.core.telescope.builtin").git_status() end,
      desc = "[G]it: status",
    },
    {
      "<leader>gb",
      function() require("plugins.core.telescope.builtin").git_branches() end,
      desc = "[G]it: [B]ranches",
    },
    {
      "<leader>gl",
      function() require("plugins.core.telescope.builtin").git_commits() end,
      desc = "[G]it: [L]og",
    },
    {
      "<leader>gc",
      function() require("plugins.core.telescope.builtin").git_bcommits() end,
      desc = "[G]it: buffer [C]ommits",
    },
    {
      "<leader>gc",
      function() require("plugins.core.telescope.builtin").git_bcommits_range() end,
      mode = { "v" },
      desc = "[G]it: selection [C]ommits",
    },
  },
  opts = function()
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")
    local custom_actions = require("plugins.core.telescope.actions")
    local utils = require("telescope.utils")

    return {
      defaults = {
        default_mappings = {
          i = {
            -- General insert-mode actions
            ["<CR>"] = actions.select_default,
            ["<Tab>"] = actions.move_selection_next,
            ["<C-n>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-]>"] = actions_layout.toggle_preview,
            ["<C-g>"] = actions.move_to_top, -- Like "go to top"
            ["<C-s>"] = actions.toggle_selection + actions.move_selection_next,
            ["<C-w>"] = actions.which_key,
            ["<C-c>"] = actions.close,
            ["<C-d>"] = actions.close, -- Shell-style exit, consistent with command line keymaps

            -- Open actions
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-l>"] = custom_actions.smart_open_loclist,
            ["<C-q>"] = custom_actions.smart_open_quickfix,
          },
          n = {
            -- General insert-mode actions
            ["<CR>"] = actions.select_default,
            ["<Tab>"] = actions.move_selection_next,
            ["<C-n>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-]>"] = actions_layout.toggle_preview,
            ["<C-g>"] = actions.move_to_top, -- Like "go to top"
            ["<C-s>"] = actions.toggle_selection + actions.move_selection_next,
            ["<C-w>"] = actions.which_key,
            ["<C-c>"] = actions.close,
            ["<C-d>"] = actions.close, -- Shell-style exit, consistent with command line keymaps

            -- General normal-mode actions
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["G"] = actions.move_to_bottom,
            ["gg"] = actions.move_to_top,
            ["s"] = actions.toggle_selection + actions.move_selection_next,
            ["?"] = actions.which_key,
            ["q"] = actions.close,
            ["<Esc>"] = actions.close,

            -- Open actions
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-l>"] = custom_actions.smart_open_loclist,
            ["<C-q>"] = custom_actions.smart_open_quickfix,

            -- Preview actions
            ["Ì"] = actions.preview_scrolling_left, -- <M-h>
            ["Ï"] = actions.preview_scrolling_down, -- <M-j>
            ["È"] = actions.preview_scrolling_up, -- <M-k>
            ["|"] = actions.preview_scrolling_right, -- <M-l>
          },
        },
        file_ignore_patterns = { "%.git/" }, -- Exclude in all searches (even when hidden & ignored files are included)
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            width = { 0.9, max = 150 },
            preview_width = 0.4,
          },
          vertical = {
            prompt_position = "top",
            mirror = true, -- Move preview to the bottom instead of above the prompt
            width = { 0.8, max = 150 },
            preview_height = 0.4,
          },
        },
        path_display = function(_, path) -- Make the path displayed more user-friendly
          return utils.transform_path({ path_display = { truncate = true } }, vim.fn.fnamemodify(path, ":p:~:."))
        end,
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf") -- Enable telescope fzf native, if installed
  end,
}
