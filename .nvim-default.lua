return {

  -- Set `light_mode` to true to disable all the plugins related to GitHub's Copilot or to external tools managed with
  -- Mason. Consequently, if this mode is activated, all the options below have no effect.
  light_mode = false,

  -- Set `disable_copilot` to true to disable GitHub's Copilot & its related plugins. This is particularly important
  -- when no GitHub Copilot subscription is available.
  disable_copilot = false,

  -- Set `environment_variables` to a mapping between environment variable names and their values to automatically set
  -- them.
  environment_variables = {},

  -- Set `treesitter_ensure_installed` to a list of Treesitter languages which are automatically installed on Neovim
  -- startup, if missing
  treesitter_ensure_installed = {
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
    "markdown_inline", -- For advanced Markdown stuff, like concealing
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
    "vimdoc", -- For Vim help files
    "yaml",
  },

  -- Set `language_servers_by_ft` to a mapping between filetypes and tables of language server configurations to enable
  -- the corresponding language servers on the filetype. See nvim-lsp-config for details on the language server
  -- configuration tables.
  language_servers_by_ft = {
    json = { jsonls = {} },
    lua = {
      lua_ls = { -- Basic LS features with type annotation checking and some linting
        settings = {
          Lua = { -- LS settings go in there (see https://luals.github.io/wiki/settings/)
            -- Disable diagnostics when passing to a function a table without the full expected type (e.g. when leaving
            -- some values to their default)
            diagnostics = { disable = { "missing-fields" } },
          },
        },
      },
    },
    markdown = { marksman = {} },
    python = {
      -- Pyright, a static type checker developped by Microsoft, provides basic LS and type checking features, but
      -- misses some advanced LS features, which are reserved for Pylance, Microsoft dedicated and close-source LSP.
      -- Basedpyright is built on top of Pyright to provide those more advanced LS features, as well as additional type
      -- checking features.
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              -- Relax the type checking mode. The default mode raises a lot of warnings and errors, which are more
              -- suited when used as the main type checker of a project, similarly to Mypy's strict mode.
              typeCheckingMode = "standard",
            },
          },
        },
      },
      -- Linting and formatting, along with related code actions
      ruff = {},
    },
    rust = {
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = { -- LS settings go in there (see https://rust-analyzer.github.io/manual.html)
            -- Add parentheses when completing with a function instead of call snippets
            completion = { callable = { snippets = "add_parentheses" } },
          },
        },
      },
    },
    toml = { taplo = {} }, -- Linting, formating and known schema validation/documentation
    typescript = { ts_ls = {} },
    typst = {
      tinymist = { -- Basic LS features with popular formatters support
        settings = {
          formatterMode = "typstyle", -- Default formatter
        },
      },
    },
    yaml = { yamlls = {} }, -- Validation, completion and documentation for knwon schemas
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
    python = { "ruff_fix", lsp_format = "last" }, -- Ruff lint fixes & Ruff LSP formatting
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
    toml = {}, -- Basic diagnostics are already integrated by the Taplo LSP
    yaml = { "yamllint" },
    zsh = { "shellcheck" }, -- Not actually for zsh, but in my case it works fine when disabling a few rules
  },

  -- Set `disable_lint_on_fts` to an array of filetypes to disable lint on those filetypes, or to "*" to disable it on
  -- all files.
  disable_lint_on_fts = false,

  -- Set `documentation_convention_by_ft` to a mapping between filetypes and names of documentation convention to use.
  -- See Neogen (https://github.com/danymat/neogen) for the builtin available conventions, and
  -- lua/plugins/core/neogen.lua for the custom ones.
  documentation_convention_by_ft = {
    python = "google_docstrings_custom",
  },

  -- Set `tooling_blacklist_path_patterns` to a list of path patterns to exclude the files matching those patterns from
  -- all tooling (format on save and lint).
  tooling_blacklist_path_patterns = {
    -- Directories inside projects but managed by external tools
    "/%.git/",
    "/%.venv",

    -- Global directories managed by package managers
    "^~/%.tmux/",
    "^~/%.local/share/nvim/",
  },

  -- Set `extra_filename_to_filetype` to a dictionary mapping file names to their corresponding file types, to support
  -- additional filetype detection for files whose name is not known by Neovim.
  extra_filename_to_filetype = {
    [".env.example"] = "sh", -- same as `.env`
    [".env.sample"] = "sh", -- same as `.env`
    [".env.test"] = "sh", -- same as `.env`
    [".env.test.example"] = "sh", -- same as `.env`
    [".prettierignore"] = "gitignore",
    ["ignore"] = "gitignore",
  },

  -- Set `extra_filename_to_icon_name` to a dictionnary mapping file names to their corresponding nvim-web-devicons
  -- icon name, to support additional icon detection for files whose name is not known by Neovim. The filetypes defined
  -- in `extra_filename_to_filetype` will be used automatically to define the corresponding icons, so there is not
  -- need to repeat them here, but `extra_filename_to_icon_name` will overwrite any value found in
  -- `extra_filename_to_filetype`.
  extra_filename_to_icon_name = {
    [".env.example"] = ".env",
    [".env.sample"] = ".env",
    [".env.test"] = ".env",
    [".env.test.example"] = ".env",
    ["ignore"] = "ignore",
  },
}
