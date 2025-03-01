return {

  -- Set `light_mode` to true to disable all the plugins related to GitHub Copilot or to external tools managed with
  -- Mason.nvim. Consequently, if this mode is activated, all the options become irrelevant.
  light_mode = false,

  -- Set `disable_copilot` to true to disable GitHub Copilot related plugins. This is particularly useful when no GitHub
  -- Copilot subscription is available, to prevent the spam of warning messages.
  disable_copilot = false,

  -- Set `environment_variables` to a mapping between environment variable names and values to set.
  environment_variables = {},

  -- Set `treesitter_ensure_installed` to a list of Treesitter languages to enable. They will be automatically installed
  -- on Neovim startup when missing.
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
    "sql",
    "ssh_config",
    "tmux",
    "toml",
    "typst",
    "vim",
    "vimdoc", -- Vim help files
    "yaml",
  },

  -- Set `language_servers_by_ft` to a mapping between filetypes and tables of language server configurations to enable.
  -- See nvim-lsp-config for details on the language server configuration tables. Introducing a new language server will
  -- likely require to install it with Mason.nvim, which can be done by calling the `MasonInstallAll` command. Setting a
  -- language server configuration table to false will disable the language server, while setting the whole
  -- `language_servers_by_ft` table to false will disable all language servers.
  language_servers_by_ft = {
    json = {
      jsonls = {},
    },
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
    markdown = {
      marksman = {},
    },
    python = {
      -- Pyright provides basic LS and advanced type checking features. However, it misses some more advanced LS
      -- features, which are reserved for Pylance, Microsoft's dedicated and close-source LSP.
      -- Basedpyright is built on top of Pyright to provide the more advanced LS features Pyright is missing, as well as
      -- additional type checking features.
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              -- Relax the type checking mode. The default mode raises a lot of warnings and errors, which are more
              -- suited when used as the main type checker of a project, similarly to Mypy's strict mode. Stricter modes
              -- can be used on a per-project basis where basedpyright is used as the main type checker.
              typeCheckingMode = "standard",
            },
          },
        },
      },
      ruff = {}, -- Linting and formatting, integrated with code actions
    },
    toml = {
      taplo = {}, -- Linting, formating and known schema validation/documentation
    },
    typst = {
      tinymist = { -- Basic LS features with popular formatters support
        settings = {
          formatterMode = "typstyle", -- Default formatter
        },
      },
    },
    yaml = {
      yamlls = {}, -- Validation, completion and documentation for knwon schemas
    },
  },

  -- Set `formatters_by_ft` to a mapping between filetypes and tables of formatters to enable in the given order.
  -- Introducing a new formatter will likely require to install it with Mason.nvim, which can be done by calling the
  -- `MasonInstallAll` command. In the formatters table, you can set `lsp_format` to `"first"`, `"last"`, or
  -- `"callback"` to enable LSP formatting. Setting a formatters table to false will disable formatting on the
  -- corresponding filetype while setting the whole `formatters_by_ft` table to false will disable formatting
  -- altogether. To disable auto-formatting but enable manual formatting (with `gq`), use
  -- `disable_format_on_save_on_fts` below.
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
    python = {
      "ruff_organize_imports", -- Apply Ruff import organization
      lsp_format = "last", -- If enabled, the Ruff LSP will provide formatting
    },
    sh = { "shfmt" },
    text = { "trim_newlines", "trim_whitespace" },
    tmux = { "trim_newlines", "trim_whitespace" },
    toml = { lsp_format = "first" }, -- If enabled, the taplo LSP will provide formatting
    typst = { lsp_format = "first" }, -- If enabled, the tinymist LSP will provide formatting
    vim = { "trim_newlines", "trim_whitespace" },
    yaml = {
      "prettier",
      "trim_newlines", -- Prettier doesn't remove trailing new lines in YAML
    },
    zsh = { "shfmt" }, -- Not actually for zsh, but in my use case it works fine
  },

  -- Set `disable_format_on_save_on_fts` to an array of filetypes on which to disable format-on-save, or to "*" to
  -- disable it on all file types.
  disable_format_on_save_on_fts = false,

  -- Set `linters_by_ft` to a mapping between filetypes and tables of linters to enable. Introducing a new linter will
  -- likely require to install it with Mason.nvim, which can be done by calling the `MasonInstallAll` command. Setting a
  -- linters table to false will disable linting on the corresponding filetype, while setting the whole `linters_by_ft`
  -- table to false will disable linting altogether.
  linters_by_ft = {
    json = { "jsonlint" },
    markdown = { "markdownlint" },
    yaml = { "yamllint" },
    zsh = { "shellcheck" }, -- Not actually for zsh, but in my case it works fine when disabling a few rules
  },

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
    ["uv.lock"] = "toml",
    ["poetry.lock"] = "toml",
  },

  -- Set `extra_filename_to_icon_name` to a dictionnary mapping file names to their corresponding nvim-web-devicons
  -- icon name, to support additional icon detection for files whose name is not known by Neovim. The filetypes defined
  -- in `extra_filename_to_filetype` will be used automatically to define the corresponding icons, so there is no
  -- need to repeat them here, but `extra_filename_to_icon_name` will overwrite any value found in
  -- `extra_filename_to_filetype`.
  extra_filename_to_icon_name = {
    [".env.example"] = ".env",
    [".env.sample"] = ".env",
    [".env.test"] = ".env",
    [".env.test.example"] = ".env",
    ["ignore"] = "ignore",
  },

  -- Set `extra_icon_names_to_icon_data` to a dictionary mapping icon names to their corresponding icon data, to support
  -- additional icons. Icon data is generally defined using exising icons data, with:
  -- `lua print(require("nvim-web-devicons").get_icon_colors("<icon-name>"))`.
  extra_icon_names_to_icon_data = {
    [".env"] = { icon = "", color = "#faf743", cterm_color = "227", name = ".env" },
    ["conf"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
    ["ignore"] = { icon = "", color = "#51a0cf", cterm_color = 74, name = "ignore" },
    ["json"] = { icon = "", color = "#cbcb41", cterm_color = 185, name = "json" },
    ["tmux"] = { icon = "", color = "#14ba19", cterm_color = "34", name = "tmux" },
    ["vim"] = { icon = "", color = "#019833", cterm_color = 28, name = "vim" },
  },
}
