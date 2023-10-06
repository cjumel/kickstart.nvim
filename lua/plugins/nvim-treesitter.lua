-- Nvim-treesitter
--
-- Neovim implementation of treesitter, implementing several features (code highlighting,
-- navigation or edition), based on a language parser. Parsers exist for many languages.

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { -- Languages treesitter must install
        "bash",
        "csv",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "requirements",
        "sql",
        "toml",
        "vim",
        "yaml",
      },
      sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
      auto_install = false, -- Autoinstall languages that are not installed
      ignore_install = {}, -- List of parsers to ignore installing (or "all")
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<leader>i",
          node_incremental = "<leader>i",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = { -- You can use the capture groups defined in textobjects.scm
            -- Class
            ["ac"] = { query = "@class.outer", desc = "a class" },
            ["ic"] = { query = "@class.inner", desc = "inner class" },

            -- Function definition
            ["am"] = { query = "@function.outer", desc = "a function defintion" },
            ["im"] = { query = "@function.inner", desc = "inner function definition" },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            -- Class
            ["[c"] = { query = "@class.outer", desc = "Next class start" },

            -- Function definition
            ["[m"] = { query = "@function.outer", desc = "Next function definition start" },
          },
          goto_next_end = {
            -- Class
            ["[C"] = { query = "@class.outer", desc = "Next class end" },

            -- Function definition
            ["[M"] = { query = "@function.outer", desc = "Next function definition end" },
          },
          goto_previous_start = {
            -- Class
            ["]c"] = { query = "@class.outer", desc = "Previous class start" },

            -- Function definition
            ["]m"] = { query = "@function.outer", desc = "Previous function definition start" },
          },
          goto_previous_end = {
            -- Class
            ["]C"] = { query = "@class.outer", desc = "Previous class end" },

            -- Function definition
            ["]M"] = { query = "@function.outer", desc = "Previous function definition end" },
          },
        },
      },
    })

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- vim-way: ; goes to the direction you were moving.
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
  end,
}
