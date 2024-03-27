-- telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    -- General keymaps
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume Telescope",
    },
    {
      "<leader>s",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "[S]earch fuzzily in buffer",
    },

    -- Main finders
    {
      "<leader>ff",
      function()
        local builtin = require("telescope.builtin")
        local oil = require("oil")

        local custom_utils = require("utils")

        local opts = {
          -- Use fd default command
          find_command = { "fd", "--type", "f", "--color", "never" },
          preview = { hide_on_startup = true },
          prompt_title = "Find Files",
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = oil.get_current_dir()
        end
        if custom_utils.visual.is_visual_mode() then
          opts.default_text = custom_utils.visual.get_text()
        end

        -- Hacky trick to be able to live-change the current picker
        vim.g.telescope_find_files_opts = opts

        builtin.find_files(opts)
      end,
      mode = { "n", "v" },
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fo",
      function()
        require("telescope.builtin").oldfiles({
          preview = { hide_on_startup = true },
          -- Keep entries sorted by recency when typing the prompt
          tiebreak = function(current_entry, existing_entry, _)
            return current_entry.index < existing_entry.index
          end,
          prompt_title = "Find Old Files",
        })
      end,
      desc = "[F]ind: [O]ld files",
    },
    {
      "<leader>fd",
      function()
        local builtin = require("telescope.builtin")
        local oil = require("oil")
        local previewers = require("telescope.previewers")

        local custom_utils = require("utils")

        local opts = {
          -- Use fd default command with directory type
          find_command = { "fd", "--type", "d", "--color", "never" },
          preview = { hide_on_startup = true },
          prompt_title = "Find Directories",
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = oil.get_current_dir()
        end
        if custom_utils.visual.is_visual_mode() then
          opts.default_text = custom_utils.visual.get_text()
        end

        -- Hacky trick to be able to live-change the current picker
        vim.g.telescope_find_files_opts = opts

        -- Use a previwer with colors for directories
        -- This must be done after saving the options in the global variable as the previewer
        -- option can't be saved (it causes an error when re-creating the picker)
        opts.previewer = previewers.vim_buffer_cat.new(opts)

        builtin.find_files(opts)
      end,
      mode = { "n", "v" },
      desc = "[F]ind: [D]irectories",
    },
    {
      "<leader>fg",
      function()
        local builtin = require("telescope.builtin")
        local oil = require("oil")

        local custom_utils = require("utils")

        local opts = {
          prompt_title = "Find by Grep",
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = oil.get_current_dir()
        end
        if custom_utils.visual.is_visual_mode() then
          opts.default_text = custom_utils.visual.get_text()
        end

        -- Hacky trick to be able to live-change the current picker
        vim.g.telescope_live_grep_opts = opts

        builtin.live_grep(opts)
      end,
      mode = { "n", "v" },
      desc = "[F]ind: by [G]rep",
    },

    -- Vim- or Neovim-related
    {
      "<leader>:",
      function()
        local opts = require("telescope.themes").get_dropdown({
          previewer = false,
          layout_config = { width = 0.7 },
        })
        -- Keep entries sorted by recency when typing the prompt
        opts.tiebreak = function(current_entry, existing_entry, _)
          return current_entry.index < existing_entry.index
        end
        -- Filter out short commands like "w", "q", "wq", "wqa"
        opts.filter_fn = function(cmd)
          return string.len(cmd) >= 4
        end
        require("telescope.builtin").command_history(opts)
      end,
      desc = "Command history",
    },
    {
      "<leader>/",
      function()
        local opts = require("telescope.themes").get_dropdown({
          previewer = false,
          layout_config = { width = 0.7 },
        })
        -- Keep entries sorted by recency when typing the prompt
        opts.tiebreak = function(current_entry, existing_entry, _)
          return current_entry.index < existing_entry.index
        end
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
        require("telescope.builtin").git_commits({ prompt_title = "Git Log" })
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
        require("telescope.builtin").keymaps({
          prompt_title = "Keymaps",
        })
      end,
      desc = "Help: [K]eymaps",
    },
    {
      "<leader>?h",
      function()
        require("telescope.builtin").help_tags({
          prompt_title = "Help Tags",
        })
      end,
      desc = "Help: [H]elp tags",
    },
  },
  config = function()
    local actions = require("telescope.actions")
    local actions_generate = require("telescope.actions.generate")
    local action_state = require("telescope.actions.state")
    local builtin = require("telescope.builtin")
    local layout_actions = require("telescope.actions.layout")
    local previewers = require("telescope.previewers")
    local utils = require("telescope.utils")

    local custom_utils = require("utils")

    local concat_arrays = custom_utils.table.concat_arrays

    require("telescope").setup({
      defaults = {
        default_mappings = {

          -- Insert mode is useful for any complex search, typically the ones that output files
          -- It is not in cases where Telescope is just used as a user-friendly interface
          i = {
            ["<CR>"] = actions.select_default,
            ["<C-c>"] = actions.close,
            ["<C-d>"] = actions.close,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-h>"] = actions.move_to_top, -- Go to highest match

            ["<C-]>"] = layout_actions.toggle_preview, -- Actually <C-$> on my keyboard

            ["<C-i>"] = actions.toggle_selection + actions.move_selection_next,
            ["<C-o>"] = actions.toggle_selection + actions.move_selection_previous,

            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,

            -- Define custom actions to open output list with Trouble while keeping it lazy-loaded
            ["<C-q>"] = function(prompt_bufnr, _mode)
              local trouble = require("trouble")
              actions.smart_send_to_qflist(prompt_bufnr, _mode)
              trouble.open("quickfix")
            end,
            ["<C-l>"] = function(prompt_bufnr, _mode)
              local trouble = require("trouble")
              actions.smart_send_to_loclist(prompt_bufnr, _mode)
              trouble.open("loclist")
            end,
            ["<C-t>"] = function(prompt_bufnr, _mode)
              local trouble_actions = require("trouble.providers.telescope")
              trouble_actions.smart_open_with_trouble(prompt_bufnr, _mode)
            end,
          },

          -- Normal mode is useful when Telescope is only used as a user-friendly interface or
          -- when accessing features not implemented in insert mode, like preview scrolling
          -- or the help
          n = {
            ["<CR>"] = actions.select_default,
            ["<ESC>"] = actions.close,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["G"] = actions.move_to_bottom,
            ["gg"] = actions.move_to_top,

            ["p"] = layout_actions.toggle_preview,
            ["u"] = actions.preview_scrolling_up,
            ["d"] = actions.preview_scrolling_down,
            ["f"] = actions.preview_scrolling_right,
            ["b"] = actions.preview_scrolling_left,

            ["?"] = actions_generate.which_key({
              only_show_current_mode = false,
            }),
          },
        },
        -- Exclude some directories in all searches, even when hidden & ignored files are included
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
          -- Normalize and shorten the path
          path = custom_utils.path.normalize(path)

          -- Apply Telescope builtin path display options (must be done after other normalizations)
          return utils.transform_path({ path_display = { truncate = true } }, path)
        end,
      },
      pickers = {
        -- Implement live-change of pickers for `find_files` & `live_grep`, to be able to search
        -- in hidden & ignored files & directories with <C-^> and <C-_>, and revert back to the
        -- default behavior with <C-z>
        find_files = {
          mappings = {
            i = {
              ["<C-z>"] = function(prompt_bufnr, _)
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_find_files_opts
                if opts.prompt_title == "Find Directories" then
                  opts.previewer = previewers.vim_buffer_cat.new(opts)
                end
                opts.default_text = current_picker:_get_prompt()

                actions.close(prompt_bufnr)
                builtin.find_files(opts)
              end,
              ["<C-^>"] = function(prompt_bufnr, _)
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_find_files_opts
                if opts.prompt_title == "Find Directories" then
                  opts.previewer = previewers.vim_buffer_cat.new(opts)
                end
                opts.find_command = concat_arrays({ opts.find_command, { "--hidden" } })
                opts.prompt_title = opts.prompt_title .. " (include hidden)"
                opts.default_text = current_picker:_get_prompt()

                actions.close(prompt_bufnr)
                builtin.find_files(opts)
              end,
              ["<C-_>"] = function(prompt_bufnr, _)
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_find_files_opts
                if opts.prompt_title == "Find Directories" then
                  opts.previewer = previewers.vim_buffer_cat.new(opts)
                end
                opts.find_command =
                  concat_arrays({ opts.find_command, { "--hidden", "--no-ignore" } })
                opts.prompt_title = opts.prompt_title .. " (include hidden & ignored)"
                opts.default_text = current_picker:_get_prompt()

                actions.close(prompt_bufnr)
                builtin.find_files(opts)
              end,
            },
          },
        },
        live_grep = {
          mappings = {
            i = {
              ["<C-z>"] = function(prompt_bufnr, _)
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_live_grep_opts
                opts.default_text = current_picker:_get_prompt()

                actions.close(prompt_bufnr)
                builtin.live_grep(opts)
              end,
              ["<C-^>"] = function(prompt_bufnr, _)
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_live_grep_opts
                opts.additional_args = { "--hidden" }
                opts.prompt_title = opts.prompt_title .. " (include hidden)"
                opts.default_text = current_picker:_get_prompt()

                actions.close(prompt_bufnr)
                builtin.live_grep(opts)
              end,
              ["<C-_>"] = function(prompt_bufnr, _)
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_live_grep_opts
                opts.additional_args = { "--hidden", "--no-ignore" }
                opts.prompt_title = opts.prompt_title .. " (include hidden & ignored)"
                opts.default_text = current_picker:_get_prompt()

                actions.close(prompt_bufnr)
                builtin.live_grep(opts)
              end,
            },
          },
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
  end,
}
