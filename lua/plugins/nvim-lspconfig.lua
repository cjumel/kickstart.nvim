-- nvim-lspconfig
--
-- Define the LSP configurations. This is where the plugins related to LSP should be installed.

return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Useful status updates for LSP
    { "j-hui/fidget.nvim", tag = "legacy", opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",

    -- nvim-cmp supports additional completion capabilities
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",

    -- For code navigation
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
  ft = {
    "lua",
    "python",
  },
  config = function()
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      -- Documentation
      nmap("K", vim.lsp.buf.hover, "[K] hover documentation")
      nmap("<leader>K", vim.lsp.buf.signature_help, "[K] signature documentation")

      -- Code edition
      local lsp_formatting = function()
        vim.lsp.buf.format({
          filter = function(client)
            -- Enable only null-ls formatting, not other LSPs
            return client.name == "null-ls"
          end,
          bufnr = bufnr,
        })
      end
      nmap("<leader>cf", lsp_formatting, "[C]ode: [F]ormat")
      nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode: [R]ename")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      -- Go to actions
      nmap("gd", vim.lsp.buf.definition, "[G]o to [D]efinition")
      nmap("gtd", vim.lsp.buf.type_definition, "[G]o to [T]ype [D]efinition")
      nmap("gD", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
      nmap("gi", vim.lsp.buf.implementation, "[G]o to [I]mplementation")
      nmap("gr", function()
        require("trouble").open("lsp_references")
      end, "[G]o to [R]eferences")
      nmap(
        "gsd",
        require("telescope.builtin").lsp_document_symbols,
        "[G]o to [S]ymbols in [D]ocument"
      )
      nmap(
        "gsw",
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        "[G]o to [S]ymbols in [W]orkspace"
      )
    end

    -- mason-lspconfig requires that these setup functions are called in this order
    -- before setting up the servers.
    require("mason").setup()
    require("mason-lspconfig").setup()

    -- Enable the following language servers. They will automatically be installed.
    -- Add any additional override configuration in the following tables. They will be passed to
    -- the `settings` field of the server config. If you want to override the default filetypes that
    -- your language server will attach to you can define the property 'filetypes' to the map in
    -- question.
    local servers = {
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
      pyright = {},
    }

    -- Setup neovim lua configuration
    require("neodev").setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Fix pyright irrelevant diagnostics when something is not used
    -- See: https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1439132189
    capabilities.textDocument.publishDiagnostics = { tagSupport = { valueSet = { 2 } } }

    -- Ensure the servers above are installed
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        })
      end,
    })
  end,
}
