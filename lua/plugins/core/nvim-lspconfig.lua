---@type nvim_config.LanguageServers
local default_language_servers = {
  bashls = {
    filetypes = { "sh", "zsh" }, -- Not actually for zsh, but works fine for me
    mason = "bash-language-server",
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
  biome = { -- Lint and format for typescript
    filetypes = { "typescript" },
  },
  jsonls = {
    filetypes = { "json" },
    mason = "json-lsp",
  },
  lua_ls = {
    filetypes = { "lua" },
    mason = "lua-language-server",
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
    mason = "rust-analyzer",
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
  ts_ls = { -- Pure LSP features for typescript
    filetypes = { "typescript" },
    mason = "typescript-language-server",
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
    mason = "yaml-language-server",
  },
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  ft = function() -- `vim.g.language_servers` is not known at this stage so it can't be used
    local filetypes = {}
    for _, server in pairs(default_language_servers) do
      if server then
        for _, filetype in ipairs(server.filetypes) do
          if not vim.tbl_contains(filetypes, filetype) then
            table.insert(filetypes, filetype)
          end
        end
      end
    end
    return filetypes
  end,
  config = function()
    ---@type nvim_config.LanguageServers
    local language_servers = vim.tbl_deep_extend("force", default_language_servers, vim.g.language_servers or {})

    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    for name, language_server in pairs(language_servers) do
      if language_server then
        table.insert(mason_ensure_installed, language_server.mason or name)
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("NvimLspconfigKeymaps", { clear = true }),
      callback = function(event)
        ---@param mode string|string[]
        ---@param lhs string
        ---@param rhs string|function
        ---@param opts table
        local function map(mode, lhs, rhs, opts)
          opts.buffer = event.buf
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        map("n", "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature help" }) -- Insert-mode keymap is handled by blink.cmp
        map("n", "gd", "<cmd>Trouble lsp_definitions<CR>", { desc = "Go to definition" })
        map("n", "grt", "<cmd>Trouble lsp_type_definitions<CR>", { desc = "LSP: type definition" })
        map("n", "grd", "<cmd>Trouble lsp_declarations<CR>", { desc = "LSP: declaration" })
        map("n", "gri", "<cmd>Trouble lsp_implementations<CR>", { desc = "LSP: implementation" })
        map("n", "grr", "<cmd>Trouble lsp_references<CR>", { desc = "LSP: references" })
        map("n", "gra", vim.lsp.buf.code_action, { desc = "LSP: code actions" })
        map("n", "grn", vim.lsp.buf.rename, { desc = "LSP: rename" })
      end,
    })

    local automatic_enable = {}
    for name, language_server in pairs(language_servers) do
      if language_server then
        table.insert(automatic_enable, name)
        vim.lsp.config(name, language_server.config or {})
      end
    end
    require("mason-lspconfig").setup({ automatic_enable = automatic_enable })
  end,
}
