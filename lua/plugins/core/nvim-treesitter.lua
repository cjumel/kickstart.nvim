return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
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
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to text-object if not on one
        keymaps = {
          ["aa"] = { query = "@parameter.outer", desc = "argument" },
          ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
          ["ac"] = { query = "@class.outer", desc = "class definition" },
          ["ic"] = { query = "@class.inner", desc = "inner class definition" },
          ["af"] = { query = "@call.outer", desc = "function call" },
          ["if"] = { query = "@call.inner", desc = "inner function call" },
          ["ag"] = { query = "@comment.outer", desc = "comment" }, -- "g" like builtin "gc" operator
          ["ig"] = { query = "@comment.inner", desc = "inner comment" }, -- "g" like builtin "gc" operator
          ["ai"] = { query = "@conditional.outer", desc = "if/else if/else statement" },
          ["ii"] = { query = "@conditional.inner", desc = "inner if/else if/else statement" },
          ["al"] = { query = "@loop.outer", desc = "loop" },
          ["il"] = { query = "@loop.inner", desc = "inner loop" },
          ["am"] = { query = "@function.outer", desc = "method definition" },
          ["im"] = { query = "@function.inner", desc = "inner method definition" },
          ["ar"] = { query = "@return.outer", desc = "return statement" },
          ["ir"] = { query = "@return.inner", desc = "inner return statement" },
          ["a="] = { query = "@assignment.outer", desc = "assignment" },
          ["i="] = { query = "@assignment.inner", desc = "inner assignment" },
          ["gl"] = { query = "@assignment.lhs", desc = "Left-hand-side of assignment" },
          ["gr"] = { query = "@assignment.rhs", desc = "Right-hand-side of assignment" },
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- Set jumps in the jumplist
        goto_next_start = {
          ["[c"] = { query = "@class.outer", desc = "Next class definition start" },
          ["[g"] = { query = "@comment.outer", desc = "Next comment" },
          ["[m"] = { query = "@function.outer", desc = "Next function definition start" },
        },
        goto_next_end = {
          ["[C"] = { query = "@class.outer", desc = "Next class definition end" },
          ["[M"] = { query = "@function.outer", desc = "Next function definition end" },
        },
        goto_previous_start = {
          ["]c"] = { query = "@class.outer", desc = "Previous class definition start" },
          ["]g"] = { query = "@comment.outer", desc = "Previous comment" },
          ["]m"] = { query = "@function.outer", desc = "Previous function definition start" },
        },
        goto_previous_end = {
          ["]C"] = { query = "@class.outer", desc = "Previous class definition end" },
          ["]M"] = { query = "@function.outer", desc = "Previous function definition end" },
        },
      },
    },
  },
  config = function(_, opts)
    local ts_config = require("nvim-treesitter.configs")
    ts_config.setup(opts)
  end,
}
