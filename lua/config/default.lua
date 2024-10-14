vim.g.neovim_config = {

  -- Set `light_mode` to true to disable all the plugins related to GitHub's Copilot or to external tools managed with
  --  Mason. Consequently, if this mode is activated, all the options below have no effect.
  light_mode = false,

  -- Set `disable_copilot` to true to disable GitHub's Copilot & its related plugins. This is particularly important
  --  when no GitHub Copilot subscription is available.
  disable_copilot = false,

  -- Set `formatters_by_ft` to a mapping between filetypes and tables of formatters to enable the corresponding
  --  formatters on the filetype, in the provided order. Introducing a new formatter will require it to be installed
  --  with Mason, but in simple cases, simply calling the `MasonInstallAll` command should work just fine. In the
  --  formatter table, you can use `lsp_format = "first"` or `"callback"` to enable formatting through the
  --  corresponding LSP. Setting a formatter table to an empty table will disable formatting on the corresponding
  --  filetype.
  formatters_by_ft = {
    conf = { "trim_newlines", "trim_whitespace" },
    editorconfig = { "trim_newlines", "trim_whitespace" },
    gitconfig = { "trim_newlines", "trim_whitespace" },
    gitignore = { "trim_newlines", "trim_whitespace" },
    json = { "prettier" },
    jsonc = { "prettier" },
    lua = { "stylua" },
    make = { "trim_newlines", "trim_whitespace" },
    markdown = { "prettier" }, -- Prettier is the only formatter I found which supports GitHub Flavored Markdown
    python = { "ruff_fix", "ruff_format" }, -- Lint diagnostic automatic fixes & regular formatting
    sh = { "shfmt" },
    text = { "trim_newlines", "trim_whitespace" },
    tmux = { "trim_newlines", "trim_whitespace" },
    toml = { lsp_format = "first" }, -- Use Taplo LSP formatting
    typst = { lsp_format = "first" }, -- Use tinymist LSP formatting (don't work with "trim_newlines")
    vim = { "trim_newlines", "trim_whitespace" },
    yaml = { "prettier", "trim_newlines" }, -- Prettier doesn't remove trailing new lines in YAML
    zsh = { "shfmt" }, -- Not actually for zsh, but in my use case it works fine
  },

  -- Set `disable_format_on_save_on_fts` to an array of filetypes to disable format-on-save on those filetypes, or
  --  to "*" to disable it on all files.
  disable_format_on_save_on_fts = false,

  -- Set `linters_by_ft` to a mapping between filetypes and tables of linters to enable the corresponding linters on the
  --  filetype. Introducing a new linter will require it to be installed with Mason, but in simple cases, simply calling
  --  the `MasonInstallAll` command should work just fine. Setting a linters table to an empty table will disable
  --  linting on the corresponding filetype.
  linters_by_ft = {
    json = { "jsonlint" },
    lua = {}, -- Basic diagnostics are already integrated by the Lua_LS LSP
    markdown = { "markdownlint" },
    python = { "ruff" },
    toml = {}, -- Basic diagnostics are already integrated by the Taplo LSP
    yaml = { "yamllint" },
    zsh = { "shellcheck" }, -- Not actually for zsh, but in my case it works fine when disabling a few rules
  },
}
