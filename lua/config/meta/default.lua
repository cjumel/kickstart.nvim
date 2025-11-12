return {

  -- Set `enable_copilot_plugins` to true to enable the GitHub Copilot related plugins. This will however require an
  -- active GitHub Copilot subscription, otherwise a warning message will be spammed.
  enable_copilot_plugins = false,

  -- Set `formatters_by_ft` to a mapping between filetypes and tables of formatters to enable in the given order.
  -- Introducing a new formatter will likely require to install it with Mason.nvim, which can be done by calling the
  -- `MasonInstallAll` command. In the formatters table, you can set `lsp_format` to `"first"`, `"last"`, or
  -- `"callback"` to enable LSP formatting. Setting a formatters table to false will disable formatting on the
  -- corresponding filetype while setting the whole `formatters_by_ft` table to false will disable formatting
  -- altogether. To disable autoformatting on save but enable manual formatting (with `gq`), use
  -- `disable_autoformat_on_fts` below.
  formatters_by_ft = {
    conf = { "trim_newlines", "trim_whitespace" },
    editorconfig = { "trim_newlines", "trim_whitespace" },
    gitconfig = { "trim_newlines", "trim_whitespace" },
    gitignore = { "trim_newlines", "trim_whitespace" },
    javascript = { "biome" },
    json = { "jq" },
    lua = { "stylua" },
    make = { "trim_newlines", "trim_whitespace" },
    markdown = { "mdformat" },
    proto = { "trim_newlines", "trim_whitespace" },
    python = {
      "ruff_organize_imports", -- Apply Ruff import organization
      lsp_format = "last", -- If enabled, the Ruff LSP will provide formatting
    },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    text = { "trim_newlines", "trim_whitespace" },
    tmux = { "trim_newlines", "trim_whitespace" },
    toml = { lsp_format = "first" }, -- If enabled, the taplo LSP will provide formatting
    typescript = { "biome" },
    typst = { lsp_format = "first" }, -- If enabled, the tinymist LSP will provide formatting
    vim = { "trim_newlines", "trim_whitespace" },
    yaml = { "yamlfmt", "trim_newlines" },
    zsh = { "shfmt" }, -- Not actually for zsh, but in my use case it works fine
  },

  -- Set `formatter_name_to_mason_name` to a mapping between formatter names and the corresponding Mason package name to
  -- install. Set a value to the empty string to prevent Mason from installing any package for the corresponding
  -- formatter.
  formatter_name_to_mason_name = {
    ruff_organize_imports = "ruff",
    rustfmt = "", -- Should be installed with rustup
  },

  -- Set `disable_autoformat_on_fts` to an array of filetypes on which to disable autoformatting on save, or to "*" to
  -- disable it on all file types.
  disable_autoformat_on_fts = false,

  -- Set `disable_autoformat_on_files` to a list of path patterns to exclude the files matching those patterns from
  -- autoformatting on save.
  disable_autoformat_on_files = {},

  -- Set `linters_by_ft` to a mapping between filetypes and tables of linters to enable. Introducing a new linter will
  -- likely require to install it with Mason.nvim, which can be done by calling the `MasonInstallAll` command. Setting a
  -- linters table to false will disable linting on the corresponding filetype, while setting the whole `linters_by_ft`
  -- table to false will disable linting altogether.
  linters_by_ft = {
    json = { "jsonlint" },
    markdown = { "markdownlint" },
    python = { "ruff" },
    yaml = { "yamllint" },
    zsh = { "shellcheck" }, -- Not actually for zsh, but in my case it works fine when disabling a few rules
  },

  -- Set `disable_lint_on_files` to a list of path patterns to exclude the files matching those patterns from linting.
  disable_lint_on_files = {},

  -- Set `disable_tooling_on_files` to a list of path patterns to exclude the files matching those patterns from all
  -- tooling (autoformatting on save and lint).
  disable_tooling_on_files = {
    -- Directories inside projects but managed by external tools
    "/%.git/",
    "/%.venv",

    -- Global directories managed by package managers
    "^~/%.tmux/",
    "^~/%.local/share/nvim/",
  },

  -- Set `documentation_convention_by_ft` to a mapping between filetypes and names of documentation convention to use.
  -- See Neogen (https://github.com/danymat/neogen) for the builtin available conventions, and
  -- lua/plugins/core/neogen.lua for the custom ones.
  documentation_convention_by_ft = {
    python = "google_docstrings_custom",
  },
}
