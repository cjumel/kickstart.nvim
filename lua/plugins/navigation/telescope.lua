-- telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

--- Telescope picker for finding directories. This function is directly adapted from the
--- `find_files` picker of Telescope.
---@param opts table<string,any>|nil Options for the picker
local find_directories = function(opts)
  local conf = require("telescope.config").values
  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")
  local previewers = require("telescope.previewers")
  local utils = require("telescope.utils")

  local Path = require("plenary.path")

  opts = opts or {}
  if not opts.find_command then
    return
  end
  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  end

  local lookup_keys = {
    ordinal = 1,
    value = 1,
    filename = 1,
    cwd = 2,
  }

  local handle_entry_index = function(opts_, t, k)
    local override = ((opts_ or {}).entry_index or {})[k]
    if not override then
      return
    end

    local val, save = override(t, opts_)
    if save then
      rawset(t, k, val)
    end
    return val
  end

  local gen_from_directory = function(opts_)
    opts_ = opts_ or {}

    local cwd = opts_.cwd or vim.loop.cwd()
    if cwd == nil then
      return
    end
    cwd = vim.fn.expand(cwd)

    local disable_devicons = opts_.disable_devicons

    local mt_file_entry = {}

    mt_file_entry.cwd = cwd
    mt_file_entry.display = function(entry)
      local hl_group, icon
      local display = utils.transform_path(opts_, entry.value)

      display, hl_group, icon = utils.transform_devicons(entry.value, display, disable_devicons)

      -- Custom part: replace the icon at the beginning of the display by a directory icon
      local new_icon = ""
      display = string.sub(display, #icon + 1)
      display = new_icon .. display
      hl_group = "Directory"

      if hl_group then
        return display, { { { 0, #icon }, hl_group } }
      else
        return display
      end
    end

    mt_file_entry.__index = function(t, k)
      local override = handle_entry_index(opts_, t, k)
      if override then
        return override
      end

      local raw = rawget(mt_file_entry, k)
      if raw then
        return raw
      end

      if k == "path" then
        local retpath = Path:new({ t.cwd, t.value }):absolute()
        if not vim.loop.fs_access(retpath, "R") then
          retpath = t.value
        end
        return retpath
      end

      return rawget(t, rawget(lookup_keys, k))
    end

    return function(line)
      return setmetatable({ line }, mt_file_entry)
    end
  end

  opts.entry_maker = gen_from_directory(opts)

  pickers
    .new(opts, {
      prompt_title = "Find Directories",
      __locations_input = true,
      finder = finders.new_oneshot_job(opts.find_command, opts),
      -- Custom part: change the previwer for one more adapted to directories
      previewer = previewers.vim_buffer_cat.new(opts),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

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

    -- Find files
    {
      "<leader>ff",
      function()
        local opts = {
          find_command = { "fd", "--type", "f", "--color", "never" }, -- Default fd command
          preview = { hide_on_startup = true },
          prompt_title = "Find Files",
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
          prompt_title = "Find Files incl. Hidden",
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
          prompt_title = "Find All Files",
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
          -- Keep entries sorted by recency when typing the prompt
          tiebreak = function(current_entry, existing_entry, _)
            return current_entry.index < existing_entry.index
          end,
          prompt_title = "Find Old Files",
        })
      end,
      desc = "[F]ind: [O]ld files",
    },

    -- Find directories
    {
      "<leader>fd",
      function()
        local opts = {
          find_command = { -- Default fd command with directory type & hidden files
            "fd",
            "--type",
            "d",
            "--color",
            "never",
            "--hidden",
            "--exclude",
            ".git",
          },
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        find_directories(opts)
      end,
      desc = "[F]ind: [D]irectories",
    },
    {
      "<leader>fD",
      function()
        local opts = {
          find_command = { -- Default fd command with directory type, hidden & ignored files
            "fd",
            "--type",
            "d",
            "--color",
            "never",
            "--hidden",
            "--exclude",
            ".git",
            "--no-ignore",
          },
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        find_directories(opts)
      end,
      desc = "[F]ind: [D]irectories (unrestricted)",
    },

    -- Find with grep
    {
      "<leader>fg",
      function()
        local opts = {
          prompt_title = "Find by Live Grep",
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").live_grep(opts)
      end,
      desc = "[F]ind: by live [G]rep",
    },
    {
      "<leader>fG",
      function()
        local opts = {
          additional_args = { "-uu" },
          prompt_title = "Find by Live Grep",
        }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").live_grep(opts)
      end,
      desc = "[F]ind: by live [G]rep (unrestricted)",
    },
    {
      "<leader>fw",
      function()
        local opts = {}
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
        local opts = {}
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").grep_string(opts)
      end,
      mode = { "v" },
      desc = "[F]ind word",
    },
    {
      "<leader>fW",
      function()
        local opts = { additional_args = { "-uu" } }
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
        local opts = { additional_args = { "-uu" } }
        if vim.bo.filetype == "oil" then
          opts.cwd = require("oil").get_current_dir()
        end
        require("telescope.builtin").grep_string(opts)
      end,
      mode = { "v" },
      desc = "[F]ind word (unrestricted)",
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
    {
      "<leader>gL",
      function()
        require("telescope.builtin").git_bcommits({ prompt_title = "Git Buffer Log" })
      end,
      desc = "[G]it: buffer [L]og",
    },
    {
      "<leader>g",
      function()
        require("telescope.builtin").git_bcommits_range({ prompt_title = "Git Selection Log" })
      end,
      mode = "v",
      desc = "[G]it: selection log",
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
            ["S"] = actions.toggle_selection + actions.move_selection_previous,

            ["<TAB>"] = layout_actions.toggle_preview,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-f>"] = actions.preview_scrolling_right,
            ["<C-b>"] = actions.preview_scrolling_left,

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

          -- Normalize and shorten the path
          local utils = require("utils")
          path = utils.path.normalize(path)

          return path
        end,
      },
      pickers = {
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
