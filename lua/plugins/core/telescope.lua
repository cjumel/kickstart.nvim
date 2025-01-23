-- telescope.nvim
--
-- telescope.nvim is a plugin which enables to gaze deeply into unknown regions of your code with powerful and blazing
-- fast fuzzy finding tools. It is one of the most essential plugins I use. It provides a really versatile interface,
-- suited for many use-cases beyond fuzzy-finding files, like LSP reference navigation, or user input selection.
-- Besides, it is very easily customizable, easier by crafting complex options or by creating extensions.

local custom_actions = require("plugins.core.telescope.actions")
local custom_builtin = require("plugins.core.telescope.builtin")

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
    -- Main finders
    { "<leader>ff", custom_builtin.find_files, mode = { "n", "v" }, desc = "[F]ind: [F]iles" },
    { "<leader>fd", custom_builtin.find_directories, mode = { "n", "v" }, desc = "[F]ind: [D]irectories" },
    { "<leader>fg", custom_builtin.live_grep, mode = { "n", "v" }, desc = "[F]ind: by [G]rep" },
    { "<leader>fr", custom_builtin.recent_files, mode = { "n", "v" }, desc = "[F]ind: [R]ecent files" },
    { "<leader>fo", custom_builtin.old_files, mode = { "n", "v" }, desc = "[F]ind: [O]ld files" },
    { "<leader>fl", custom_builtin.find_lines, mode = { "n", "v" }, desc = "[F]ind: [L]ines" },

    -- Help-related
    { "<leader>?h", custom_builtin.help_tags, desc = "Help: help tags" },
    { "<leader>?c", custom_builtin.commands, desc = "Help: commands" },
    { "<leader>?k", custom_builtin.keymaps, desc = "Help: keymaps" },

    -- Neovim-related
    { "<leader><Tab>", custom_builtin.buffers, desc = "Buffer switcher" },
    { "<leader>,", custom_builtin.resume, desc = "Resume Telescope" },
    { "<leader>:", custom_builtin.command_history, desc = "Command history" },
    { "<leader>/", custom_builtin.search_history, desc = "Search history" },

    -- Git-related
    { "<leader>gg", custom_builtin.git_status, desc = "[G]it: status" },
    { "<leader>gl", custom_builtin.git_commits, desc = "[G]it: [L]og" },
    { "<leader>gL", custom_builtin.git_bcommits, desc = "[G]it: buffer [L]og" },
    { "<leader>gl", custom_builtin.git_bcommits_range, mode = { "v" }, desc = "[G]it: selection [L]og" },
  },
  opts = function()
    local actions = require("telescope.actions")
    local layout_actions = require("telescope.actions.layout")
    return {
      defaults = {
        default_mappings = {
          i = {
            -- General insert-mode actions
            ["<CR>"] = actions.select_default,
            ["<S-CR>"] = actions.toggle_selection + actions.move_selection_next,
            ["<Tab>"] = actions.move_selection_next,
            ["<C-n>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-]>"] = layout_actions.toggle_preview,
            ["<C-g>"] = actions.move_to_top, -- Like "go to top"
            ["<C-h>"] = actions.which_key, -- Like "help"
            ["<C-c>"] = actions.close,
            ["<C-d>"] = actions.close, -- Shell-style exit, consistent with command line keymaps

            -- Open actions
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-l>"] = custom_actions.smart_open_loclist,
            ["<C-q>"] = custom_actions.smart_open_quickfix,

            -- Preview actions
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-k>"] = actions.preview_scrolling_up,

            -- Fix isert-mode delete word action
            ["<C-w>"] = { "<C-S-w>", type = "command" },
          },
          n = {
            -- General insert-mode actions
            ["<CR>"] = actions.select_default,
            ["<S-CR>"] = actions.toggle_selection + actions.move_selection_next,
            ["<Tab>"] = actions.move_selection_next,
            ["<C-n>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-]>"] = layout_actions.toggle_preview,
            ["<C-g>"] = actions.move_to_top, -- Like "go to top"
            ["<C-h>"] = actions.which_key, -- Like "help"
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
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-k>"] = actions.preview_scrolling_up,
            ["H"] = actions.preview_scrolling_left,
            ["J"] = actions.preview_scrolling_down,
            ["K"] = actions.preview_scrolling_up,
            ["L"] = actions.preview_scrolling_right,
          },
        },
        file_ignore_patterns = { "%.git/" }, -- Exclude in all searches (even when hidden & ignored files are included)
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            width = { 0.9, max = 150 },
            preview_width = 0.4,
            preview_cutoff = 100, -- Number of columns below which the preview is always hidden
          },
          vertical = {
            prompt_position = "top",
            mirror = true, -- Move preview to the bottom instead of above the prompt
            width = { 0.8, max = 150 },
            preview_height = 0.4,
            preview_cutoff = 20, -- Number of lines below which the preview is always hidden
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
