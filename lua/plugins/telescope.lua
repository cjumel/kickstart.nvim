-- Telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

local create_user_cmd = function()
  vim.api.nvim_create_user_command("GitStashList", function()
    require("telescope.builtin").git_stash()
  end, { desc = "Git stash list" })
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    "folke/trouble.nvim",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  cmd = {
    "GitStashList",
  },
  keys = {
    -- General
    {
      "<leader>tr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "[T]elescope [R]esume",
    },

    -- Find files
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          find_command = { "rg", "--files", "--hidden" },
        })
      end,
      desc = "[F]ind [F]iles",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({
          find_command = { "rg", "--files", "--hidden" },
          follow = true,
          no_ignore = true,
        })
      end,
      desc = "[F]ind [A]ll files",
    },
    {
      "<leader>fo",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "[F]ind [O]ld files",
    },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "[F]ind [C]hanges",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "[F]ind [B]uffers",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "[F]ind by [G]rep",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "[F]ind [W]ord under the cursor",
    },

    -- Git-related
    {
      "<leader>gb",
      function()
        require("telescope.builtin").git_branches()
      end,
      desc = "[G]it [B]ranches",
    },
    {
      "<leader>gl",
      function()
        require("telescope.builtin").git_commits()
      end,
      desc = "[G]it [L]og",
    },

    -- Vim- or Neovim-related
    {
      "<leader><leader>",
      function()
        local opts = require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        })

        -- Simplify the display of commands with only name & description
        local displayer = require("telescope.pickers.entry_display").create({
          separator = "▏",
          items = {
            { width = 0.33 },
            { remaining = true },
          },
        })
        local make_display = function(entry)
          return displayer({
            { entry.name, "TelescopeResultsIdentifier" },
            entry.definition,
          })
        end
        local entry_maker = function(entry)
          return {
            name = entry.name,
            bang = entry.bang,
            nargs = entry.nargs,
            complete = entry.complete,
            definition = entry.definition,
            --
            value = entry,
            valid = true,
            ordinal = entry.name,
            display = make_display,
          }
        end
        opts.entry_maker = entry_maker

        require("telescope.builtin").commands(opts)
      end,
      desc = "[ ] Find fuzzily in commands",
    },
    {
      "<leader>:",
      function()
        require("telescope.builtin").command_history(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "[:] Find fuzzily in command history",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          })
        )
      end,
      desc = "[/] Find fuzzily in buffer",
    },
    {
      "<leader>m",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "[M]appings",
    },
    {
      "<leader>ht",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "[H]elp [T]ags",
    },
  },
  init = function()
    create_user_cmd()
  end,
  config = function()
    create_user_cmd()

    local actions = require("telescope.actions")
    local trouble = require("trouble.providers.telescope")
    require("telescope").setup({
      defaults = {
        n = {
          ["="] = actions.select_default,
          ["<c-t>"] = trouble.open_with_trouble,
        },
        mappings = {
          i = {
            ["<c-t>"] = trouble.open_with_trouble,
          },
        },
        -- vimgrep_arguments is used for live_grep and grep_string
        vimgrep_arguments = {
          "rg",
          "--color=never", -- must not be removed
          "--no-heading", -- must not be removed
          "--with-filename", -- must not be removed
          "--line-number", -- must not be removed
          "--column", -- must not be removed
          "--smart-case",
          "--hidden",
        },
        file_ignore_patterns = {
          ".git/",
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
  end,
}
