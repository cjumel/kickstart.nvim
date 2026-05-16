local M = {}

---@type nvim_config.MasonPackageVersions
M.mason_package_versions = {
  basedpyright = "1.39.0",
  ["bash-language-server"] = "5.6.0",
  biome = "2.4.10",
  debugpy = "1.8.20",
  ["json-lsp"] = "4.10.0",
  ["lua-language-server"] = "3.18.0",
  marksman = "2026-02-08",
  ruff = "0.15.9",
  rumdl = "v0.1.67",
  ["rust-analyzer"] = "2026-04-06",
  shellcheck = "v0.11.0",
  shfmt = "v3.13.0",
  stylua = "v2.4.1",
  taplo = "0.10.0",
  tinymist = "v0.14.16",
  ["typescript-language-server"] = "5.1.3",
  ["yaml-language-server"] = "1.21.0",
  yamlfmt = "v0.21.0",
  yamllint = "1.38.0",
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
