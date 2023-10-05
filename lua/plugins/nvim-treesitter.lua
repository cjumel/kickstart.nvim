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
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_next_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
          goto_previous_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_previous_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
        },
      },
    })
  end,
}
