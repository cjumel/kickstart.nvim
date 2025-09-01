local servers_by_ft = {
  json = { jsonls = {} },
  lua = {
    lua_ls = {
      settings = {
        Lua = {
          -- Disable noisy diagnostics when passing to a function a table without the full expected type
          diagnostics = { disable = { "missing-fields" } },
        },
      },
    },
  },
  markdown = { marksman = {} },
  python = {
    basedpyright = {
      settings = {
        basedpyright = {
          analysis = { typeCheckingMode = "standard" }, -- Relax type checking rules
        },
      },
      on_init = function(client, _)
        -- Disable semantic tokens as it degrades the syntax highlighting provided by Treesitter
        client.server_capabilities.semanticTokensProvider = nil
      end,
    },
    ruff = {},
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
  typescript = { ts_ls = {} },
  typst = {
    tinymist = {
      settings = {
        formatterMode = "typstyle", -- Use the default formatter
      },
    },
  },
  yaml = { yamlls = {} },
}

local server_name_to_mason_name = {
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
    "hrsh7th/cmp-nvim-lsp",
  },
  ft = vim.tbl_keys(servers_by_ft),
  init = function()
    local mason_ensure_installed = {}
    for _, ft_servers in pairs(servers_by_ft) do
      for server_name, _ in pairs(ft_servers) do
        local mason_name = server_name_to_mason_name[server_name] or server_name
        table.insert(mason_ensure_installed, mason_name)
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("NvimLspconfigKeymaps", { clear = true }),
      callback = function(event)
        ---@param mode string|string[] The mode(s) of the keymap.
        ---@param lhs string The left-hand side of the keymap.
        ---@param rhs string|function The right-hand side of the keymap.
        ---@param desc string The description of the keymap.
        local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = event.buf }) end
        map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "gd", "<cmd>Trouble lsp_definitions<CR>", "Go to definition")
        map("n", "grt", "<cmd>Trouble lsp_type_definitions<CR>", "LSP: type definition")
        map("n", "grd", "<cmd>Trouble lsp_declarations<CR>", "LSP: declation")
        map("n", "gri", "<cmd>Trouble lsp_implementations<CR>", "LSP: implementation")
        map("n", "grr", "<cmd>Trouble lsp_references<CR>", "LSP: references")
        map("n", "gra", vim.lsp.buf.code_action, "LSP: code actions")
        map("n", "grn", vim.lsp.buf.rename, "LSP: rename")
      end,
    })

    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

    for _, servers in pairs(servers_by_ft) do
      for name, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[name].setup(config)
      end
    end

    mason_lspconfig.setup({ automatic_enable = false })
  end,
}
