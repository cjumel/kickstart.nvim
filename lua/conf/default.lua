return {

  -- Set `light_mode` to true to disable all the plugins related to GitHub's Copilot or to external tools managed with
  -- Mason. Consequently, if this mode is activated, all the options below have no effect.
  light_mode = false,

  -- Set `disable_copilot` to true to disable GitHub's Copilot & its related plugins. This is particularly important
  -- when no GitHub Copilot subscription is available.
  disable_copilot = false,

  -- In `language_servers`, define the language servers to use and their configuration overrides.
  -- Available keys for overrides are:
  --  - cmd (table): Override the default command used to start the server
  --  - filetypes (table): Override the default list of associated filetypes for the server
  --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP
  --    features.
  --  - settings (table): Override the default settings passed when initializing the server.
  -- In this implementation, filetypes must be defined for each server as it is used to setup Lazy, and it must be a
  -- table of strings
  language_servers = {

    -- Provide basic language server features, like symbol navigation
    jsonls = {
      filetypes = { "json" },
    },

    lua_ls = {
      filetypes = { "lua" },
      settings = {
        Lua = {
          -- Settings go here, see https://luals.github.io/wiki/settings/
          -- Some configuration for the Neovim development environment is done directly by the lazydev.nvim plugin
        },
      },
    },

    -- Marksman provides some basic LSP features for markdown files (like LSP symbols), as well as more refined features
    -- to interact with links & references (completion, renaming, preview, etc.)
    marksman = {
      filetypes = { "markdown" },
    },

    -- Pyright provides regular LSP features, as well as static type checking, replacing static type checkers
    pyright = {
      filetypes = { "python" },
      capabilities = {
        textDocument = { publishDiagnostics = { tagSupport = { valueSet = { 2 } } } }, -- Disable noisy diagnostics
      },
    },

    rust_analyzer = {
      filetypes = { "rust" },
      settings = {
        ["rust-analyzer"] = {
          -- Add parentheses when completing with a function instead of call snippets (with parentheses and argument
          -- placeholders), as replacing the argument placeholders creates a bit of unecessary complexity, and it
          -- doesn't work well with Copilot completion
          completion = { callable = { snippets = "add_parentheses" } },
        },
      },
    },

    -- Taplo provides linting, formatting and some features based on schemas from SchemaStore like validation or
    -- hovering
    taplo = {
      filetypes = { "toml" },
    },

    -- Tinymist provides LSP basic features, like go-to-declaration, auto-completion, or diagnostics, but also
    -- formatting with popular Typst formatters or compiling the PDF file on save
    tinymist = {
      filetypes = { "typst" },
      settings = {
        formatterMode = "typstyle", -- Default formatter
      },
    },

    ts_ls = {
      filetypes = { "javascript", "typescript" },
    },

    -- Provide some features based on schemas from SchemaStore like completion or hovering
    yamlls = {
      filetypes = { "yaml" },
    },
  },

  -- Set `formatters_by_ft` to a mapping between filetypes and tables of formatters to enable the corresponding
  -- formatters on the filetype, in the provided order. Introducing a new formatter will require it to be installed with
  -- Mason, but in simple cases, simply calling the `MasonInstallAll` command should work just fine. In the formatter
  -- table, you can use `lsp_format = "first"` or `"callback"` to enable formatting through the corresponding LSP.
  -- Setting a formatter table to an empty table will disable formatting on the corresponding filetype.
  formatters_by_ft = {
    conf = { "trim_newlines", "trim_whitespace" },
    editorconfig = { "trim_newlines", "trim_whitespace" },
    gitconfig = { "trim_newlines", "trim_whitespace" },
    gitignore = { "trim_newlines", "trim_whitespace" },
    javascript = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    lua = { "stylua" },
    make = { "trim_newlines", "trim_whitespace" },
    markdown = { "prettier" }, -- Prettier is the only formatter I found which supports GitHub Flavored Markdown
    python = { "ruff_fix", "ruff_format" }, -- Lint diagnostic automatic fixes & regular formatting
    rust = { "rustfmt" },
    sh = { "shfmt" },
    text = { "trim_newlines", "trim_whitespace" },
    tmux = { "trim_newlines", "trim_whitespace" },
    toml = { lsp_format = "first" }, -- Use Taplo LSP formatting
    typescript = { "prettier" },
    typst = { lsp_format = "first" }, -- Use tinymist LSP formatting (don't work with "trim_newlines")
    vim = { "trim_newlines", "trim_whitespace" },
    yaml = { "prettier", "trim_newlines" }, -- Prettier doesn't remove trailing new lines in YAML
    zsh = { "shfmt" }, -- Not actually for zsh, but in my use case it works fine
  },

  -- Set `disable_format_on_save_on_fts` to an array of filetypes to disable format-on-save on those filetypes, or to
  -- "*" to disable it on all files.
  disable_format_on_save_on_fts = false,

  -- Set `linters_by_ft` to a mapping between filetypes and tables of linters to enable the corresponding linters on the
  -- filetype. Introducing a new linter will require it to be installed with Mason, but in simple cases, simply calling
  -- the `MasonInstallAll` command should work just fine. Setting a linters table to an empty table will disable linting
  -- on the corresponding filetype.
  linters_by_ft = {
    json = { "jsonlint" },
    lua = {}, -- Basic diagnostics are already integrated by the Lua_LS LSP
    markdown = { "markdownlint" },
    python = { "ruff" },
    toml = {}, -- Basic diagnostics are already integrated by the Taplo LSP
    yaml = { "yamllint" },
    zsh = { "shellcheck" }, -- Not actually for zsh, but in my case it works fine when disabling a few rules
  },

  -- Set `disable_lint_on_fts` to an array of filetypes to disable lint on those filetypes, or to "*" to disable it on
  -- all files.
  disable_lint_on_fts = false,

  -- Set `tooling_blacklist_path_patterns` to a list of path patterns to exclude the files matching those patterns from
  -- all tooling (format on save & lint).
  tooling_blacklist_path_patterns = {
    -- Patterns for directories inside my projects but managed by external tools, like Git or package managers (e.g.
    -- Python virtual environements)
    "/%.git/",
    "/%.venv",

    -- Patterns for directories managed by package managers but which I sometimes open directly with Neovim, like Tmux
    -- plugins
    "^~/%.tmux/",
  },
}
