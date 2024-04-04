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
    local themes = require("telescope.themes")
    local utils = require("telescope.utils")

    local custom_utils = require("utils")

    local concat_arrays = custom_utils.table.concat_arrays

    local nmap = custom_utils.keymap.nmap
    local nvmap = custom_utils.keymap.nvmap

    -- [[ Global utilities ]]
    -- Utilities to manipulate the global state of Neovim, in order to be able to recreate
    -- an existing Picker, for instance to change its parameters dynamically.

    --- Save Picker options in the global state.
    ---@param opts table The options to save.
    ---@return nil
    local function save_opts(opts) vim.g.telescope_last_opts = opts end

    --- Load Picker options from the global state.
    ---@return table
    local function load_opts() return vim.g.telescope_last_opts end

    --- Finalize options before passing them to Telescope. This is necessary to compute options
    --- which can't or soulnd't be saved in the global state. Note that options which have been
    --- finalized must not be saved afterwards. If a prompt buffer number is provided, the prompt
    --- will be closed and the default text will be set to the prompt's text.
    ---@param opts table The options to finalize.
    ---@param prompt_bufnr number|nil The prompt buffer number, if any.
    ---@return table
    local function finalize_opts(opts, prompt_bufnr)
      -- Add additional information in the prompt when relevant
      local prompt_title_extras = {}

      if prompt_bufnr ~= nil then
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        opts.default_text = current_picker:_get_prompt()
        actions.close(prompt_bufnr)
      end

      -- `previwers.vim_buffer_cat` can't be saved to state for some reason, so let's work around
      -- this by saving & loading the options instead
      if opts._cat_previewer_opts ~= nil then
        opts.previewer = previewers.vim_buffer_cat.new(opts._cat_previewer_opts)
      end

      if opts._use_oil_directory and opts._oil_directory then
        table.insert(prompt_title_extras, custom_utils.path.normalize(opts._oil_directory))
        opts.cwd = opts._oil_directory
      end

      if opts._hidden and not opts._hidden_and_ignored then
        table.insert(prompt_title_extras, "w/ hidden")
        if opts.prompt_title == "Find Files" or opts.prompt_title == "Find Directories" then
          opts.find_command = concat_arrays({ opts.find_command, { "--hidden" } })
        elseif opts.prompt_title == "Find by Grep" then
          opts.additional_args = { "--hidden" }
        end
      end
      if not opts._hidden and opts._hidden_and_ignored then
        table.insert(prompt_title_extras, "all")
        if opts.prompt_title == "Find Files" or opts.prompt_title == "Find Directories" then
          opts.find_command = concat_arrays({ opts.find_command, { "--hidden", "--no-ignore" } })
        elseif opts.prompt_title == "Find by Grep" then
          opts.additional_args = { "--hidden", "--no-ignore" }
        end
      end

      if #prompt_title_extras ~= 0 then
        opts.prompt_title = opts.prompt_title
          .. " ("
          .. table.concat(prompt_title_extras, ", ")
          .. ")"
      end

      return opts
    end

    --- Output a function to toggle the hidden files option in a Picker.
    ---@param picker function The picker to toggle the hidden files option in.
    ---@return function
    local function live_set_hidden(picker)
      return function(prompt_bufnr, _)
        local opts = load_opts()
        opts._hidden = not opts._hidden
        opts._hidden_and_ignored = false

        save_opts(opts)
        picker(finalize_opts(opts, prompt_bufnr))
      end
    end

    --- Output a function to toggle the hidden and ignored files option in a Picker.
    ---@param picker function The picker to toggle the hidden and ignored files option in.
    ---@return function
    local function live_set_hidden_and_ignored(picker)
      return function(prompt_bufnr, _)
        local opts = load_opts()
        opts._hidden = false
        opts._hidden_and_ignored = not opts._hidden_and_ignored

        save_opts(opts)
        picker(finalize_opts(opts, prompt_bufnr))
      end
    end

    --- Output a function to toggle the Oil directory option in a Picker.
    ---@param picker function The picker to toggle the Oil directory option in.
    ---@return function
    local function live_set_cwd(picker)
      return function(prompt_bufnr, _)
        local opts = load_opts()
        opts._use_oil_directory = not opts._use_oil_directory

        save_opts(opts)
        picker(finalize_opts(opts, prompt_bufnr))
      end
    end

    -- [[ Telescope setup ]]

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
          path = custom_utils.path.normalize(path) -- Normalize and shorten the path
          -- Apply Telescope builtin path display options (must be done after other normalizations)
          return utils.transform_path({ path_display = { truncate = true } }, path)
        end,
      },
      pickers = {
        find_files = {
          mappings = {
            i = {
              ["<C-^>"] = live_set_hidden(builtin.find_files),
              ["<C-_>"] = live_set_hidden_and_ignored(builtin.find_files),
              ["<C-c>"] = live_set_cwd(builtin.find_files),
            },
          },
        },
        live_grep = {
          mappings = {
            i = {
              ["<C-^>"] = live_set_hidden(builtin.live_grep),
              ["<C-_>"] = live_set_hidden_and_ignored(builtin.live_grep),
              ["<C-c>"] = live_set_cwd(builtin.live_grep),
            },
          },
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(telescope.load_extension, "fzf")

    -- [[ Keymap utilities ]]

    --- Keep entries sorted by recency when typing the prompt
    local function recency_tiebreak(current_entry, existing_entry, _)
      return current_entry.index < existing_entry.index
    end

    --- Make options dynamically depend on the Picker context and add a persistence layer.
    ---@param opts table Options to make.
    ---@param meta_opts table Meta options establishing how to make the options.
    ---@return table opts The final options.
    local function make_opts(opts, meta_opts)
      if meta_opts.oil_directory == true then
        if vim.bo.filetype == "oil" then
          opts._oil_directory = oil.get_current_dir() -- To keep the Oil directory in memory
          opts._use_oil_directory = true
        end
      end
      if meta_opts.visual_mode == true then
        if custom_utils.visual.is_visual_mode() then
          opts.default_text = custom_utils.visual.get_text()
        end
      end

      save_opts(opts)
      return finalize_opts(opts)
    end

    -- [[ Keymaps ]]

    -- General keymaps
    nmap("<leader><leader>", builtin.resume, "Resume Telescope")
    nvmap(
      "<leader>s",
      function() builtin.current_buffer_fuzzy_find(make_opts({}, { visual_mode = true })) end,
      "[S]earch fuzzily in buffer"
    )

    -- Main finders
    nvmap("<leader>ff", function()
      builtin.find_files(make_opts({
        find_command = { "fd", "--type", "f", "--color", "never" },
        preview = { hide_on_startup = true },
        prompt_title = "Find Files", -- Necessary for dynamic picker changes
      }, { oil_directory = true, visual_mode = true }))
    end, "[F]ind: [F]iles")
    nvmap("<leader>fd", function()
      builtin.find_files(make_opts({
        find_command = { "fd", "--type", "d", "--color", "never" },
        preview = { hide_on_startup = true },
        _cat_previewer_opts = {}, -- Use a previewer with colors for directories
        prompt_title = "Find Directories",
      }, { oil_directory = true, visual_mode = true, cat_previwer = true }))
    end, "[F]ind: [D]irectories")
    nvmap(
      "<leader>fg",
      function()
        builtin.live_grep(make_opts({
          prompt_title = "Find by Grep",
        }, { oil_directory = true, visual_mode = true }))
      end,
      "[F]ind: by [G]rep"
    )
    nvmap(
      "<leader>fo",
      function()
        builtin.oldfiles(make_opts({
          preview = { hide_on_startup = true },
          tiebreak = recency_tiebreak,
          prompt_title = "Find OldFiles",
        }, { visual_mode = true }))
      end,
      "[F]ind: [O]ldfiles"
    )
    nvmap( -- Alternative to oldfiles but only with files in cwd
      "<leader>fr",
      function()
        builtin.oldfiles(make_opts({
          preview = { hide_on_startup = true },
          tiebreak = recency_tiebreak,
          prompt_title = "Find Recent Files",
          cwd_only = true,
        }, { visual_mode = true }))
      end,
      "[F]ind: [R]ecent files"
    )

    -- Vim- or Neovim-related
    nmap("<leader>:", function()
      builtin.command_history(themes.get_dropdown({
        previewer = false,
        layout_config = { width = 0.7 },
        tiebreak = recency_tiebreak,
        -- Filter out short commands like "w", "q", "wq", "wqa"
        filter_fn = function(cmd) return string.len(cmd) >= 4 end,
      }))
    end, "Command history")
    nmap(
      "<leader>/",
      function()
        builtin.search_history(themes.get_dropdown({
          previewer = false,
          layout_config = { width = 0.7 },
          tiebreak = recency_tiebreak,
        }))
      end,
      "Search history"
    )

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
