return {

  -- Set `enable_all_plugins` to true to enable all plugins, for updating purposes. Note that this will trigger minor
  -- usability issues, with incompatible plugins like color schemes, but this shouldn't be too big of a deal.
  enable_all_plugins = false,

  -- Set `enable_copilot_plugins` to true to enable the GitHub Copilot related plugins. This will however require an
  -- active GitHub Copilot subscription, otherwise a warning message will be spammed.
  enable_copilot_plugins = false,

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
    lua = { "stylua" },
    make = { "trim_newlines", "trim_whitespace" },
    markdown = { "mdformat" },
    python = {
      "ruff_organize_imports", -- Apply Ruff import organization
      lsp_format = "last", -- If enabled, the Ruff LSP will provide formatting
    },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    text = { "trim_newlines", "trim_whitespace" },
    tmux = { "trim_newlines", "trim_whitespace" },
    toml = { lsp_format = "first" }, -- If enabled, the taplo LSP will provide formatting
    typst = { lsp_format = "first" }, -- If enabled, the tinymist LSP will provide formatting
    vim = { "trim_newlines", "trim_whitespace" },
    yaml = { "yamlfmt" },
    zsh = { "shfmt" }, -- Not actually for zsh, but in my use case it works fine
  },

  -- Set `formatter_name_to_mason_name` to a mapping between formatter names and the corresponding Mason package name to
  -- install. Set a value to the empty string to prevent Mason from installing any package for the corresponding
  -- formatter.
  formatter_name_to_mason_name = {
    ruff_organize_imports = "ruff",
    rustfmt = "", -- Should be installed with rustup
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
    [".gitignore-global"] = ".gitignore",
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
    [".gitignore-global"] = ".gitignore",
    ["ignore"] = "ignore",
  },

  -- Set `extra_icon_names_to_icon_data` to a dictionary mapping icon names to their corresponding icon data, to support
  -- additional icons. Icon data is generally defined using exising icons data, with:
  -- `lua print(require("nvim-web-devicons").get_icon_colors("<icon-name>"))`.
  extra_icon_names_to_icon_data = {
    [".env"] = {
      icon = "",
      color = "#faf743",
      cterm_color = "227",
      name = ".env",
      _color_light = "#32310d",
      _cterm_color_light = "236",
    },
    [".gitignore"] = {
      icon = "",
      color = "#f54d27",
      cterm_color = "196",
      name = ".gitignore",
      _color_light = "#b83a1d",
      _cterm_color_light = "160",
    },
    ["conf"] = {
      icon = "",
      color = "#6d8086",
      cterm_color = 66,
      name = "conf",
      _color_light = "#526064",
      _cterm_color_light = "59",
    },
    ["ignore"] = {
      icon = "",
      color = "#51a0cf",
      cterm_color = 74,
      name = "ignore",
      _color_light = "#51a0cf",
      _cterm_color_light = "74",
    },
    ["json"] = {
      icon = "",
      color = "#cbcb41",
      cterm_color = 185,
      name = "json",
      _color_light = "#666620",
      _cterm_color_light = "58",
    },
    ["tmux"] = {
      icon = "",
      color = "#14ba19",
      cterm_color = "34",
      name = "tmux",
      _color_light = "#0f8c13",
      _cterm_color_light = "28",
    },
    ["vim"] = {
      icon = "",
      color = "#019833",
      cterm_color = 28,
      name = "vim",
      _color_light = "#017226",
      _cterm_color_light = "22",
    },
  },
}
