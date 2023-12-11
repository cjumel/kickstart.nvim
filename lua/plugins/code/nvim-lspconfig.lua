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

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",

    -- nvim-cmp supports additional completion capabilities
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",

    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "nvim-telescope/telescope.nvim",
  },
  ft = {
    "lua",
    "python",
  },
  config = function()
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- Documentation
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
      vim.keymap.set(
        { "n", "i" },
        "<C-s>",
        vim.lsp.buf.signature_help,
        { buffer = bufnr, desc = "Signature help" }
      )

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
      vim.keymap.set("n", "<leader>lf", lsp_formatting, { buffer = bufnr, desc = "[F]ormat" })
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "[R]ename" })
      vim.keymap.set(
        "n",
        "<leader>la",
        vim.lsp.buf.code_action,
        { buffer = bufnr, desc = "[A]ction" }
      )
      vim.keymap.set("n", "<leader>ld", function()
        require("telescope.builtin").lsp_document_symbols()
      end, { buffer = bufnr, desc = "[D]ocument symbols" })
      vim.keymap.set("n", "<leader>lw", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end, { buffer = bufnr, desc = "[W]orkspace symbols" })

      -- Go to actions
      vim.keymap.set("n", "gd", function()
        require("telescope.builtin").lsp_definitions({
          layout_strategy = "vertical",
          initial_mode = "normal",
          show_line = false,
        })
      end, { buffer = bufnr, desc = "Go to definition" })
      vim.keymap.set("n", "gD", function()
        require("telescope.builtin").lsp_type_definitions()
      end, { buffer = bufnr, desc = "Go to type definition" })
      vim.keymap.set("n", "gr", function()
        require("telescope.builtin").lsp_references({
          layout_strategy = "vertical",
          initial_mode = "normal",
          show_line = false,
        })
      end, { buffer = bufnr, desc = "Go to references" })
      vim.keymap.set("n", "gI", function()
        require("telescope.builtin").lsp_implementations()
      end, { buffer = bufnr, desc = "Go to implementation" })
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
          -- Ignore noisy `missing-fields` warnings
          diagnostics = { disable = { "missing-fields" } },
          -- Disable LSP snippets as they are redundant with custom ones
          completion = { keywordSnippet = "Disable" },
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
