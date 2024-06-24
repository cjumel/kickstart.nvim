-- telescope.nvim
--
-- Telescope is a plugin which enables to gaze deeply into unknown regions of your code with powerful and blazing fast
-- fuzzy finding tools. It is one of the most essential plugins I use. It provides a really versatile interface, suited
-- for many use-cases beyond fuzzy-finding files, like LSP reference navigation, or user input selection. Besides, it
-- is very easily customizable, easier by crafting complex options or by creating extensions.

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
    "stevearc/oil.nvim", -- Oil could have been lazy-loaded by Telescope but it is already not in the global setup
    {
      "nvim-telescope/telescope-fzf-native.nvim", -- Fuzzy finder algorithm requiring local dependencies to be built
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end, -- Only load if make is available
    },
  },
  cmd = { "Telescope" }, -- Especially useful for other plugins calling Telescope through a command
  keys = function()
    local builtin = require("telescope.builtin")
    local custom_builtin = require("plugins.core.telescope.builtin")

    return {
      -- Main finders
      { "<leader>ff", custom_builtin.find_files, mode = { "n", "v" }, desc = "[F]ind: [F]iles" },
      { "<leader>fd", custom_builtin.find_directories, mode = { "n", "v" }, desc = "[F]ind: [D]irectories" },
      { "<leader>fg", custom_builtin.live_grep, mode = { "n", "v" }, desc = "[F]ind: by [G]rep" },
      { "<leader>fo", custom_builtin.oldfiles, mode = { "n", "v" }, desc = "[F]ind: [O]ldfiles" },
      { "<leader>fz", custom_builtin.current_buffer, mode = { "n", "v" }, desc = "[F]ind: fu[Z]zilly in buffer" },

      -- Neovim-related
      { "<leader><leader>", builtin.resume, desc = "Resume Telescope" },
      { "<leader><Tab>", custom_builtin.buffers, desc = "Buffer switcher" },
      { "<leader>:", custom_builtin.command_history, desc = "Command history" },
      { "<leader>/", custom_builtin.search_history, desc = "Search history" },

      -- Git related
      { "<leader>gg", custom_builtin.git_status, desc = "[G]it: status" },
      { "<leader>gl", custom_builtin.git_commits, desc = "[G]it: [L]og" },
      { "<leader>gc", custom_builtin.git_bcommits, desc = "[G]it: buffer [C]ommits" },
      { "<leader>gc", custom_builtin.git_bcommits_range, mode = { "v" }, desc = "[G]it: selection [C]ommits" },
    }
  end,
  opts = function()
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")
    local custom_actions = require("plugins.core.telescope.actions")
    local custom_utils = require("utils")
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
            ["<C-g>"] = actions.move_to_top, -- Like "go to top"
            ["<C-s>"] = actions.toggle_selection + actions.move_selection_next,
            ["<C-w>"] = actions.which_key,
            ["<C-c>"] = actions.close,
            ["<C-d>"] = actions.close, -- Shell-style exit, consistent with command line keymaps

            -- Preview actions
            ["<C-]>"] = actions_layout.toggle_preview,
            ["Ì"] = actions.preview_scrolling_left, -- <M-h>
            ["Ï"] = actions.preview_scrolling_down, -- <M-j>
            ["È"] = actions.preview_scrolling_up, -- <M-k>
            ["|"] = actions.preview_scrolling_right, -- <M-l>

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

            -- Preview actions
            ["<C-]>"] = actions_layout.toggle_preview,
            ["Ì"] = actions.preview_scrolling_left, -- <M-h>
            ["Ï"] = actions.preview_scrolling_down, -- <M-j>
            ["È"] = actions.preview_scrolling_up, -- <M-k>
            ["|"] = actions.preview_scrolling_right, -- <M-l>

            -- Open actions
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-l>"] = custom_actions.smart_open_loclist,
            ["<C-q>"] = custom_actions.smart_open_quickfix,
          },
        },
        file_ignore_patterns = { "%.git/" }, -- Exclude in all searches (even when hidden & ignored files are included)
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top", -- Make text input at the top instead of the bottom
            width = { 0.8, max = 180 }, -- Add a limit to the width
            preview_width = 0.5, -- Make preview the same width as the results
          },
          vertical = {
            prompt_position = "top", -- Make text input at the top instead of the bottom
            width = { 0.8, max = 180 }, -- Add a limit to the width
            mirror = true, -- Move preview to the bottom instead of above the prompt
          },
        },
        path_display = function(_, path)
          path = custom_utils.path.normalize(path) -- Normalize and shorten the path
          -- Apply Telescope builtin path display options (must be done after other normalizations)
          return utils.transform_path({ path_display = { truncate = true } }, path)
        end,
      },
      pickers = {
        find_files = {
          mappings = {
            i = { ["<C-^>"] = custom_actions.find_files.toggle_all },
            n = { ["<C-^>"] = custom_actions.find_files.toggle_all },
          },
        },
        live_grep = {
          mappings = {
            i = { ["<C-^>"] = custom_actions.live_grep.toggle_all },
            n = { ["<C-^>"] = custom_actions.live_grep.toggle_all },
          },
        },
        git_status = { -- Override the <Tab> keymap to revert the staging/unstaging behavior of the picker
          mappings = {
            i = { ["<Tab>"] = actions.move_selection_next },
            n = { ["<Tab>"] = actions.move_selection_next },
          },
        },
        lsp_document_symbols = {
          mappings = {
            i = { ["<C-^>"] = custom_actions.lsp_document_symbols.switch_to_lsp_dynamic_workspace_symbols },
            n = { ["<C-^>"] = custom_actions.lsp_document_symbols.switch_to_lsp_dynamic_workspace_symbols },
          },
        },
        lsp_dynamic_workspace_symbols = {
          mappings = {
            i = { ["<C-^>"] = custom_actions.lsp_dynamic_workspace_symbols.switch_to_lsp_document_symbols },
            n = { ["<C-^>"] = custom_actions.lsp_dynamic_workspace_symbols.switch_to_lsp_document_symbols },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)

    pcall(telescope.load_extension, "fzf") -- Enable telescope fzf native, if installed
  end,
}
