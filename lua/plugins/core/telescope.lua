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
  keys = function()
    local custom_builtin = require("plugins.core.telescope.builtin")
    return {

      -- Main finders
      { "<leader>ff", custom_builtin.find_files, mode = { "n", "v" }, desc = "[F]ind: [F]iles" },
      { "<leader>fd", custom_builtin.find_directories, mode = { "n", "v" }, desc = "[F]ind: [D]irectories" },
      { "<leader>fg", custom_builtin.live_grep, mode = { "n", "v" }, desc = "[F]ind: by [G]rep" },
      { "<leader>fo", custom_builtin.oldfiles, mode = { "n", "v" }, desc = "[F]ind: [O]ldfiles" },
      { "<leader>fb", custom_builtin.current_buffer_fuzzy_find, mode = { "n", "v" }, desc = "[F]ind: in [B]uffer" },

      -- Help-related
      { "<leader>fm", custom_builtin.man_pages, mode = { "n", "v" }, desc = "[F]ind: [M]an pages" },
      { "<leader>fh", custom_builtin.help_tags, desc = "[F]ind: [H]elp" },
      { "<leader>fc", custom_builtin.commands, desc = "[F]ind: [C]ommands" },
      { "<leader>fk", custom_builtin.keymaps, desc = "[F]ind: [K]eymaps" },
      { "<leader>fv", custom_builtin.vim_options, desc = "[F]ind: [V]im Options" },

      -- Neovim-related
      { "<leader><Tab>", custom_builtin.buffers, desc = "Buffer switcher" },
      { "<leader>,", custom_builtin.resume, desc = "Resume Telescope" },
      { "<leader>:", custom_builtin.command_history, desc = "Command history" },
      { "<leader>/", custom_builtin.search_history, desc = "Search history" },

      -- Git-related
      { "<leader>gg", custom_builtin.git_status, desc = "[G]it: status" },
      { "<leader>gb", custom_builtin.git_branches, desc = "[G]it: [B]ranches" },
      { "<leader>gl", custom_builtin.git_commits, desc = "[G]it: [L]og" },
      { "<leader>gc", custom_builtin.git_bcommits, desc = "[G]it: buffer [C]ommits" },
      { "<leader>gc", custom_builtin.git_bcommits_range, mode = { "v" }, desc = "[G]it: selection [C]ommits" },
    }
  end,
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
            ["<M-CR>"] = actions.toggle_selection + actions.move_selection_next, -- <C-CR>
            ["<Tab>"] = actions.move_selection_next,
            ["<C-n>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-]>"] = actions_layout.toggle_preview,
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

            -- Fix delete word action in insert mode (see https://github.com/nvim-telescope/telescope.nvim/issues/1579)
            ["<C-w>"] = { "<C-S-w>", type = "command" },
            ["<M-BS>"] = { "<C-S-w>", type = "command" }, -- <C-BS>
          },
          n = {
            -- General insert-mode actions
            ["<CR>"] = actions.select_default,
            ["<M-CR>"] = actions.toggle_selection + actions.move_selection_next, -- <C-CR>
            ["<Tab>"] = actions.move_selection_next,
            ["<C-n>"] = actions.move_selection_next,
            ["<S-Tab>"] = actions.move_selection_previous,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-]>"] = actions_layout.toggle_preview,
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
            preview_cutoff = 20,
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
