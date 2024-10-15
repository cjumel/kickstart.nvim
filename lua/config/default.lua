vim.g.neovim_config = {

  -- Set `light_mode` to true to disable all the plugins related to GitHub's Copilot or to external tools managed with
  --  Mason. Consequently, if this mode is activated, all the options below have no effect.
  light_mode = false,

  -- Set `disable_copilot` to true to disable GitHub's Copilot & its related plugins. This is particularly important
  --  when no GitHub Copilot subscription is available.
  disable_copilot = false,

  -- In `language_servers`, define the language servers to use and their configuration overrides. Its structure follows
  --  closely the one supported by `nvim-lspconfig`.
  -- Available keys for overrides are:
  --  - cmd (table): Override the default command used to start the server
  --  - filetypes (table): Override the default list of associated filetypes for the server
  --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP
  --    features.
  --  - settings (table): Override the default settings passed when initializing the server.
  -- In this implementation, filetypes must be defined for each server as it is used to setup Lazy, and it must be a
  --  table of strings
  language_servers = {

    -- Provide basic language server features, like symbol navigation
    jsonls = {
      filetypes = { "json" },
    },

    -- For LuaLS detailed documentation, see: https://luals.github.io/wiki/settings/
    -- Besides regular LSP features, LuaLS provides very cool diagnostics making a linter not needed, as well as some
    --  static type checking
    -- Additional LuaLS configuration is handled by the lazydev.nvim plugin
    lua_ls = {
      filetypes = { "lua" },
      settings = {
        Lua = {
          completion = {
            -- Complete with function names instead of call snippets
            -- For a function `func` taking `a` and `b` as arguments, a call snippet is `func(a, b)` where `a` and `b`
            --  are placeholders to fill
            callSnippet = "Disable",
            -- Complete with regular keyword instead of keyword snippets
            -- Keyword snippets are snippets for keywords like `if`, `for`, `while`, etc.
            -- Custom snippets implemented with Luasnip are noticably faster, and they don't require for the LSP
            --  workspace to be loaded
            keywordSnippet = "Disable",
          },
          diagnostics = {
            disable = { "missing-fields" }, -- Ignore noisy `missing-fields` warnings
          },
        },
      },
    },

    -- Marksman provides some basic LSP features for markdown files (like LSP symbols), as well as more refined features
    --  to interact with links & references (completion, renaming, preview, etc.)
    marksman = {
      filetypes = { "markdown" },
    },

    -- Pyright provides regular LSP features, as well as static type checking, making another static type checker like
    --  mypy redundant
    pyright = {
      filetypes = { "python" },
      capabilities = {
        -- Disable noisy `variable not accessed` diagnostics
        textDocument = { publishDiagnostics = { tagSupport = { valueSet = { 2 } } } },
      },
    },

    -- Taplo provides linting, formatting and some features based on schemas from SchemaStore like validation or hovering
    taplo = {
      filetypes = { "toml" },
    },

    -- Tinymist provides many cool features for Typst, like LSP features (go to declaration, auto-completion, etc.),
    --  diagnostics, formatting with popular Typst formatters or even compiling the PDF file on save (even though I don't
    --  use this last feature, as it also compiles Typst modules which are not designed to be compiled)
    tinymist = {
      filetypes = { "typst" },
      settings = {
        formatterMode = "typstyle", -- Use Typstyle as default formatter
      },
    },

    -- Provide some features based on schemas from SchemaStore like completion or hovering
    yamlls = {
      filetypes = { "yaml" },
    },
  },

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
