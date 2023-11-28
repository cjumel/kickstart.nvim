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
      local nmap = function(keys, func, desc, has_prefix)
        has_prefix = has_prefix or true
        if desc and has_prefix then
          desc = "[L]SP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

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
      nmap("<leader>lf", lsp_formatting, "[F]ormat")
      nmap("<leader>lr", vim.lsp.buf.rename, "[R]ename")
      nmap("<leader>la", vim.lsp.buf.code_action, "[A]ction")
      nmap("<leader>ld", function()
        require("telescope.builtin").lsp_document_symbols()
      end, "[D]ocument symbols")
      nmap("<leader>lw", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end, "[W]orkspace symbols")

      -- Go to actions
      nmap("gd", function()
        require("telescope.builtin").lsp_definitions({
          layout_strategy = "vertical",
          initial_mode = "normal",
          show_line = false,
        })
      end, "[G]oto [D]efinition", false)
      nmap("gD", function()
        require("telescope.builtin").lsp_type_definitions()
      end, "[G]oto type [D]efinition", false)
      nmap("gr", function()
        require("telescope.builtin").lsp_references({
          layout_strategy = "vertical",
          initial_mode = "normal",
          show_line = false,
        })
      end, "[G]oto [R]eferences", false)
      nmap("gI", function()
        require("telescope.builtin").lsp_implementations()
      end, "[G]oto [I]mplementation", false)
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
