local M = {}

---@type nvim_config.MasonPackages
M.mason_packages = {
  { name = "basedpyright", version = "1.39.0" },
  { name = "bash-language-server", version = "5.6.0" },
  { name = "biome", version = "2.4.10" },
  { name = "debugpy", version = "1.8.20" },
  { name = "json-lsp", version = "4.10.0" },
  { name = "lua-language-server", version = "3.18.0" },
  { name = "marksman", version = "2026-02-08" },
  { name = "ruff", version = "0.15.9" },
  { name = "rumdl", version = "v0.1.67" },
  { name = "rust-analyzer", version = "2026-04-06" },
  { name = "shellcheck", version = "v0.11.0" },
  { name = "shfmt", version = "v3.13.0" },
  { name = "stylua", version = "v2.4.1" },
  { name = "taplo", version = "0.10.0" },
  { name = "tinymist", version = "v0.14.16" },
  { name = "typescript-language-server", version = "5.1.3" },
  { name = "yaml-language-server", version = "1.21.0" },
  { name = "yamlfmt", version = "v0.21.0" },
  { name = "yamllint", version = "1.38.0" },
}

---@type nvim_config.LanguageServers
M.language_servers = {
  bashls = {
    filetypes = { "sh", "zsh" }, -- Not actually for zsh, but works fine for me
    config = {
      filetypes = { "sh", "zsh" },
    },
  },
  basedpyright = { -- Pure LSP features for Python
    filetypes = { "python" },
    config = {
      settings = {
        basedpyright = {
          analysis = { typeCheckingMode = "standard" }, -- Relax default type checking rules
        },
      },
    },
  },
  biome = { -- Lint and format
    filetypes = { "javascript", "typescript" },
  },
  jsonls = {
    filetypes = { "json" },
  },
  lua_ls = {
    filetypes = { "lua" },
    config = {
      settings = {
        Lua = {
          -- Disable snippets in favor of custom ones
          completion = { keywordSnippet = "Disable" },
          -- Disable noisy diagnostics when passing to a function a table without the full expected type
          diagnostics = { disable = { "missing-fields" } },
        },
      },
    },
  },
  marksman = {
    filetypes = { "markdown" },
  },
  ruff = { -- Lint and format for Python
    filetypes = { "python" },
  },
  rumdl = {
    filetypes = { "markdown" },
  },
  rust_analyzer = {
    filetypes = { "rust" },
    config = {
      settings = {
        ["rust-analyzer"] = {
          -- Add parentheses when completing with a function instead of call snippets
          completion = { callable = { snippets = "add_parentheses" } },
        },
      },
    },
  },
  taplo = {
    filetypes = { "toml" },
  },
  tinymist = {
    filetypes = { "typst" },
    config = {
      settings = {
        formatterMode = "typstyle", -- Use the default formatter
      },
    },
  },
  ts_ls = { -- Pure LSP
    filetypes = { "javascript", "typescript" },
    config = {
      on_attach = function(client) -- Disable formatting in favor of biome
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        diagnostics = {
          ignoredCodes = {
            80006, -- "This may be converted to an async function", not relevant when chaining promises
          },
        },
      },
    },
  },
  yamlls = {
    filetypes = { "yaml" },
  },
}

---@type nvim_config.FormattersByFiletype
M.formatters_by_ft = {
  conf = { "trim_newlines", "trim_whitespace" },
  editorconfig = { "trim_newlines", "trim_whitespace" },
  gitconfig = { "trim_newlines", "trim_whitespace" },
  gitignore = { "trim_newlines", "trim_whitespace" },
  javascript = { lsp_format = "first" }, -- Biome
  json = { lsp_format = "first" }, -- JsonLS
  lua = { "stylua" },
  make = { "trim_newlines", "trim_whitespace" },
  markdown = { lsp_format = "first" }, -- rumdl
  proto = { "trim_newlines", "trim_whitespace" },
  python = {
    "ruff_organize_imports",
    lsp_format = "last", -- Ruff
  },
  rust = { "rustfmt" },
  sh = { "shfmt" },
  text = { "trim_newlines", "trim_whitespace" },
  tmux = { "trim_newlines", "trim_whitespace" },
  toml = { lsp_format = "first" }, -- Taplo
  typescript = { lsp_format = "first" }, -- Biome
  typst = { lsp_format = "first" }, -- Tinymist
  vim = { "trim_newlines", "trim_whitespace" },
  yaml = { "yamlfmt", "trim_newlines" },
  zsh = { "shfmt" }, -- Not actually for zsh, but works fine for me
}

---@type nvim_config.LintersByFiletype
M.linters_by_ft = {
  sh = { "shellcheck" },
  yaml = { "yamllint" },
  zsh = { "shellcheck" }, -- Not actually for zsh, but works fine for me
}

return M
