local servers_by_ft = {
  json = { jsonls = {} },
  lua = {
    lua_ls = {
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
  markdown = { marksman = {} },
  python = {
    basedpyright = { -- Pure LSP features
      settings = {
        basedpyright = {
          analysis = { typeCheckingMode = "standard" }, -- Relax default type checking rules
        },
      },
    },
    ruff = {}, -- Lint and format
  },
  rust = {
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          -- Add parentheses when completing with a function instead of call snippets
          completion = { callable = { snippets = "add_parentheses" } },
        },
      },
    },
  },
  toml = { taplo = {} },
  typescript = {
    ts_ls = { -- Pure LSP features
      on_attach = function(client) -- Disable formatting in favor of biome
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    },
    biome = {}, -- Lint and format
  },
  typst = {
    tinymist = {
      settings = {
        formatterMode = "typstyle", -- Use the default formatter
      },
    },
  },
  yaml = { yamlls = {} },
}

local server_to_mason_name = {
  jsonls = "json-lsp",
  lua_ls = "lua-language-server",
  rust_analyzer = "rust-analyzer",
  ts_ls = "typescript-language-server",
  yamlls = "yaml-language-server",
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  ft = vim.tbl_keys(servers_by_ft),
  config = function()
    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    for _, servers in pairs(servers_by_ft) do
      for server, _ in pairs(servers) do
        local mason_name = server_to_mason_name[server] or server
        table.insert(mason_ensure_installed, mason_name)
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

        -- General keymaps
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

    for _, servers in pairs(servers_by_ft) do
      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
      end
    end

    require("mason-lspconfig").setup()
  end,
}
