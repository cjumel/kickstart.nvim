-- TODO: change to main branch
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  lazy = false, -- Lazy-loading is not supported for this plugin
  opts = {
    ensure_installed = {
      "bash",
      "csv",
      "diff",
      "dockerfile",
      "editorconfig",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "luadoc", -- Lua docstrings
      "luap", -- Lua search patterns
      "make",
      "markdown",
      "markdown_inline", -- Advanced Markdown features (e.g. concealing)
      "proto",
      "prisma",
      "python",
      "regex",
      "requirements",
      "rust",
      "sql",
      "ssh_config",
      "tmux",
      "toml",
      "typescript",
      "typst",
      "vim",
      "vimdoc", -- Vim help files
      "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  },
  config = function(_, opts)
    local ts_config = require("nvim-treesitter.configs")
    ts_config.setup(opts)
  end,
}
