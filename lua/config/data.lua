local M = {}

---@type nvim_config.MasonPackageVersions
M.mason_package_versions = {
  basedpyright = "1.40.1",
  ["bash-language-server"] = "5.8.1",
  biome = "2.5.14",
  debugpy = "1.8.22",
  ["json-lsp"] = "4.10.0",
  ["lua-language-server"] = "3.19.1",
  marksman = "2026-02-08",
  ruff = "0.16.8",
  rumdl = "v0.2.73",
  ["rust-analyzer"] = "2026-09-21",
  shellcheck = "v0.11.0",
  shfmt = "v3.14.1",
  stylua = "v2.5.2",
  taplo = "0.10.0",
  tinymist = "v0.15.8",
  ["typescript-language-server"] = "6.0.1",
  ["yaml-language-server"] = "1.24.0",
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
    filetypes = { "javascript", "json", "typescript" },
    config = {
      -- Enable also outside of biome workspaces
      workspace_required = false,
      root_dir = function(bufnr, on_dir) on_dir(vim.fs.root(bufnr, { ".git" }) or vim.fn.getcwd()) end,
    },
  },
  jsonls = {
    filetypes = { "json" },
    config = {
      init_options = {
        provideFormatter = false,
      },
    },
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
    config = {
      handlers = {
        ["textDocument/diagnostic"] = function(err, result, ctx)
          local bufname = vim.api.nvim_buf_get_name(ctx.bufnr)
          local is_opencode_prompt = bufname:match("^/private/var/folders/.*%.md$")
          local scratch_dir = vim.pesc(vim.fn.stdpath("data") .. "/scratch/")
          local is_scratch_file = bufname:match("^" .. scratch_dir .. ".*%.markdown$")
          if result and result.items and (is_opencode_prompt or is_scratch_file) then
            result = vim.deepcopy(result)
            local missing_header_code = "MD041"
            result.items = vim.tbl_filter(
              function(diagnostic) return diagnostic.code ~= missing_header_code end,
              result.items
            )
          end
          return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
        end,
      },
    },
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
  json = { lsp_format = "first" }, -- Biome
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
