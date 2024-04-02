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
    "stevearc/oil.nvim", -- Oil could be lazy-loaded by Telescope but it is already not

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end,
    },
  },
  -- In practice, Telescope is always loaded on "VeryLazy" event, since it's a dependency of
  -- Telescope-UI-select which itself is loaded on "VeryLazy" event, so let's not bother making
  -- it lazy-loaded on keys
  event = "VeryLazy",
  config = function()
    local oil = require("oil")

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local builtin = require("telescope.builtin")
    local layout_actions = require("telescope.actions.layout")
    local previewers = require("telescope.previewers")
    local telescope = require("telescope")
    local utils = require("telescope.utils")

    local custom_utils = require("utils")

    local concat_arrays = custom_utils.table.concat_arrays

    local nmap = custom_utils.keymap.nmap
    local nvmap = custom_utils.keymap.nvmap

    telescope.setup({
      defaults = {
        default_mappings = {

          i = {
            -- General actions (shared between both modes)
            ["<CR>"] = actions.select_default,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-d>"] = actions.close, -- More convenient way to directly exit Telescope

            -- Preview actions (shared between both modes)
            ["<C-]>"] = layout_actions.toggle_preview, -- Actually <C-$> on my keyboard
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-l>"] = actions.preview_scrolling_right,

            -- Insert mode specific actions
            ["<C-g>"] = actions.move_to_top, -- Go to top
            ["<C-w>"] = actions.which_key,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
          },

          n = {
            -- General actions (shared between both modes)
            ["<CR>"] = actions.select_default,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-d>"] = actions.close, -- More convenient way to directly exit Telescope

            -- Preview actions (shared between both modes)
            ["<C-]>"] = layout_actions.toggle_preview, -- Actually <C-$> on my keyboard
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-l>"] = actions.preview_scrolling_right,

            -- Normal mode specific actions
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["G"] = actions.move_to_bottom,
            ["gg"] = actions.move_to_top,
            ["<ESC>"] = actions.close,
            ["?"] = actions.which_key,

            -- Selection-related actions
            ["s"] = actions.toggle_selection + actions.move_selection_next,
            ["S"] = actions.toggle_selection + actions.move_selection_previous,
            ["Q"] = function(prompt_bufnr, _mode)
              local trouble = require("trouble") -- Lazy loaded thanks to function wrapping
              actions.smart_send_to_qflist(prompt_bufnr, _mode)
              trouble.open("quickfix")
            end,
            ["L"] = function(prompt_bufnr, _mode)
              local trouble = require("trouble") -- Lazy loaded thanks to function wrapping
              actions.smart_send_to_loclist(prompt_bufnr, _mode)
              trouble.open("loclist")
            end,
            ["T"] = function(prompt_bufnr, _mode)
              local trouble_actions = require("trouble.providers.telescope")
              trouble_actions.smart_open_with_trouble(prompt_bufnr, _mode)
            end,
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
              ["<C-c>"] = function(prompt_bufnr, _) -- Set cwd to project's root
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_find_files_opts
                if opts.prompt_title == "Find Directories" then
                  opts.previewer = previewers.vim_buffer_cat.new(opts)
                end
                opts.cwd = vim.fn.getcwd()
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
              ["<C-c>"] = function(prompt_bufnr, _) -- Set cwd to project's root
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_live_grep_opts
                opts.cwd = vim.fn.getcwd()
                opts.default_text = current_picker:_get_prompt()

                actions.close(prompt_bufnr)
                builtin.live_grep(opts)
              end,
            },
          },
        },
        oldfiles = {
          mappings = {
            i = {
              ["<C-c>"] = function(prompt_bufnr, _) -- Set cwd to project's root
                local current_picker = action_state.get_current_picker(prompt_bufnr)

                local opts = vim.g.telescope_oldfiles_opts
                opts.cwd_only = true
                opts.default_text = current_picker:_get_prompt()

                actions.close(prompt_bufnr)
                builtin.oldfiles(opts)
              end,
            },
          },
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(telescope.load_extension, "fzf")

    -- General keymaps
    nmap("<leader><leader>", builtin.resume, "Resume Telescope")
    nvmap("<leader>s", function()
      local opts = {}
      if custom_utils.visual.is_visual_mode() then
        opts.default_text = custom_utils.visual.get_text()
      end
      builtin.current_buffer_fuzzy_find(opts)
    end, "[S]earch fuzzily in buffer")

    -- Main finders
    nvmap("<leader>ff", function()
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
    end, "[F]ind: [F]iles")
    nvmap("<leader>fo", function()
      local opts = {
        preview = { hide_on_startup = true },
        -- Keep entries sorted by recency when typing the prompt
        tiebreak = function(current_entry, existing_entry, _)
          return current_entry.index < existing_entry.index
        end,
        prompt_title = "Find Old Files",
      }
      if custom_utils.visual.is_visual_mode() then
        opts.default_text = custom_utils.visual.get_text()
      end

      -- Hacky trick to be able to live-change the current picker
      vim.g.telescope_oldfiles_opts = opts

      builtin.oldfiles(opts)
    end, "[F]ind: [O]ld files")
    nvmap("<leader>fd", function()
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
    end, "[F]ind: [D]irectories")
    nvmap("<leader>fg", function()
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
    end, "[F]ind: by [G]rep")

    -- Vim- or Neovim-related
    nmap("<leader>:", function()
      local opts = require("telescope.themes").get_dropdown({
        previewer = false,
        layout_config = { width = 0.7 },
      })
      -- Keep entries sorted by recency when typing the prompt
      opts.tiebreak = function(current_entry, existing_entry, _)
        return current_entry.index < existing_entry.index
      end
      -- Filter out short commands like "w", "q", "wq", "wqa"
      opts.filter_fn = function(cmd) return string.len(cmd) >= 4 end
      builtin.command_history(opts)
    end, "Command history")
    nmap("<leader>/", function()
      local opts = require("telescope.themes").get_dropdown({
        previewer = false,
        layout_config = { width = 0.7 },
      })
      -- Keep entries sorted by recency when typing the prompt
      opts.tiebreak = function(current_entry, existing_entry, _)
        return current_entry.index < existing_entry.index
      end
      builtin.search_history(opts)
    end, "Search history")

    -- Git related
    nmap("<leader>gs", builtin.git_status, "[G]it: [S]tatus")
    nmap("<leader>gb", builtin.git_branches, "[G]it: [B]ranches")
    nmap(
      "<leader>gl",
      function() builtin.git_commits({ prompt_title = "Git Log" }) end,
      "[G]it: [L]og"
    )
    nvmap("<leader>gL", function()
      if vim.fn.mode() == "n" then
        builtin.git_bcommits({ prompt_title = "Git Buffer Log" })
      else
        builtin.git_bcommits_range({ prompt_title = "Git Selection Log" })
      end
    end, "[G]it: buffer/selection [L]og")

    -- Help related
    nmap("<leader>?c", builtin.commands, "Help: [C]ommands")
    nmap(
      "<leader>?k",
      function() builtin.keymaps({ prompt_title = "Keymaps" }) end,
      "Help: [K]eymaps"
    )
    nmap(
      "<leader>?h",
      function() builtin.help_tags({ prompt_title = "Help Tags" }) end,
      "Help: [H]elp tags"
    )
  end,
}
