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
      cond = function() return vim.fn.executable("make") == 1 end,
    },
  },
  cmd = { "Telescope" }, -- Especially useful for other plugins calling Telescope through a command
  keys = {
    -- Main pickers
    {
      "<leader>ff",
      function() require("plugins.core.telescope.pickers").find_files() end,
      mode = { "n", "v" },
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fr",
      function() require("plugins.core.telescope.pickers").recent_files() end,
      mode = { "n", "v" },
      desc = "[F]ind: [R]ecent files",
    },
    {
      "<leader>fo",
      function() require("plugins.core.telescope.pickers").old_files() end,
      mode = { "n", "v" },
      desc = "[F]ind: [O]ld files",
    },
    {
      "<leader>fd",
      function() require("plugins.core.telescope.pickers").find_directories() end,
      mode = { "n", "v" },
      desc = "[F]ind: [D]irectories",
    },
    {
      "<leader>fl",
      function() require("plugins.core.telescope.pickers").find_lines() end,
      mode = { "n", "v" },
      desc = "[F]ind: [L]ines",
    },
    {
      "<leader>fg",
      function() require("plugins.core.telescope.pickers").live_grep() end,
      mode = { "n", "v" },
      desc = "[F]ind: by [G]rep",
    },

    -- Help-related pickers
    {
      "<leader>fh",
      function() require("plugins.core.telescope.pickers").help_tags() end,
      desc = "[F]ind: [H]elp tags",
    },
    {
      "<leader>fc",
      function() require("plugins.core.telescope.pickers").commands() end,
      desc = "[F]ind: [C]ommands",
    },
    {
      "<leader>fk",
      function() require("plugins.core.telescope.pickers").keymaps() end,
      desc = "[F]ind: [K]eymaps",
    },

    -- Neovim-related pickers
    {
      "<leader><Tab>",
      function() require("plugins.core.telescope.pickers").buffers() end,
      desc = "Buffer switcher",
    },
    {
      "<leader>,",
      function() require("plugins.core.telescope.pickers").resume() end,
      desc = "Resume Telescope",
    },
    {
      "<leader>:",
      function() require("plugins.core.telescope.pickers").command_history() end,
      desc = "Command history",
    },
    {
      "<leader>/",
      function() require("plugins.core.telescope.pickers").search_history() end,
      desc = "Search history",
    },

    -- Git-related pickers
    {
      "<leader>gg",
      function() require("plugins.core.telescope.pickers").git_status() end,
      desc = "[G]it: status",
    },
    {
      "<leader>gb",
      function() require("plugins.core.telescope.pickers").git_branches() end,
      desc = "[G]it: [B]ranch",
    },
    {
      "<leader>gl",
      function() require("plugins.core.telescope.pickers").git_commits() end,
      desc = "[G]it: [L]og",
    },
    {
      "<leader>gL",
      function() require("plugins.core.telescope.pickers").git_bcommits() end,
      desc = "[G]it: buffer [L]og",
    },
    {
      "<leader>gl",
      function() require("plugins.core.telescope.pickers").git_bcommits_range() end,
      mode = { "v" },
      desc = "[G]it: selection [L]og",
    },
  },
  opts = function()
    local actions = require("telescope.actions")
    local custom_actions = require("plugins.core.telescope.actions")
    local layout_actions = require("telescope.actions.layout")
    return {
      defaults = {
        default_mappings = {
          i = {
            -- Actions
            -- <C-t> is reserved for picker-specific toggle action
            ["<CR>"] = actions.select_default,
            ["<C-s>"] = actions.toggle_selection + actions.move_selection_next,
            ["<Tab>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Esc>"] = actions.close,
            ["<C-v>"] = layout_actions.toggle_preview, -- Like "toggle view"
            ["<C-g>"] = actions.move_to_top, -- Like "go to top"
            ["<C-h>"] = actions.which_key, -- Like "help"
            ["<C-l>"] = custom_actions.smart_open_loclist,
            ["<C-q>"] = custom_actions.smart_open_quickfix,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-k>"] = actions.preview_scrolling_up,

            -- Fix delete word keymap
            ["<C-w>"] = { "<C-S-w>", type = "command" },
            ["<M-BS>"] = { "<C-S-w>", type = "command" },
          },
          n = {
            -- Actions
            -- The normal mode is only used for the buffers picker, so let's keep the minimum amount of actions
            ["<CR>"] = actions.select_default,
            ["<Tab>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["q"] = actions.close,
            ["<Esc>"] = actions.close,
            ["?"] = actions.which_key,
          },
        },
        file_ignore_patterns = { "%.git/" }, -- Exclude in all searches (even when hidden & ignored files are included)
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            width = { 0.9, max = 150 },
            preview_width = 0.5,
            preview_cutoff = 100,
          },
          vertical = {
            prompt_position = "top",
            mirror = true, -- Move preview to the bottom instead of above the prompt
            width = { 0.8, max = 150 },
            preview_height = 0.4, -- Make results & preview windows approximately the same size
            preview_cutoff = 20,
          },
        },
        path_display = function(_, path) -- Make the path displayed more user-friendly
          return require("telescope.utils").transform_path(
            { path_display = { truncate = true } },
            vim.fn.fnamemodify(path, ":p:~:.")
          )
        end,
      },
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    pcall(require("telescope").load_extension, "fzf") -- Enable telescope fzf native, if installed
  end,
}
