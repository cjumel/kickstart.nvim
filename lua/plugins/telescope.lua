-- Telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

-- TODO:
-- - re-implement commands for stash:
-- {
--   "<leader>gshl",
--   function()
--     require("telescope.builtin").git_stash()
--   end,
--   desc = "[F]ind: git [S]tash",
-- },

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
        require("telescope.builtin").commands(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
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
    {
      "<leader>cs",
      function()
        require("telescope.builtin").colorscheme()
      end,
      desc = "[C]olor [S]cheme",
    },
  },
  config = function()
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
