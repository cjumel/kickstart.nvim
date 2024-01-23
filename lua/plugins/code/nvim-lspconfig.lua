-- nvim-lspconfig
--
-- Define the LSP configurations. This is where the plugins related to LSP should be installed.

-- ISSUE:
-- The "go to references" action often gives many duplicates in Python, see
-- https://github.com/microsoft/pylance-release/issues/5220

return {
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
    -- Illuminates references to the symbol under the cursor
    "RRethy/vim-illuminate",
  },
  ft = {
    "lua",
    "python",
  },
  config = function()
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Documentation
      map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature help" })

      -- Code edition
      map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "[L]SP: [R]ename" })
      map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "[L]SP: [A]ction" })

      -- Code search
      map("n", "<leader>ld", function()
        require("telescope.builtin").lsp_document_symbols()
      end, { desc = "[L]SP: [D]ocument symbols" })
      map("n", "<leader>lw", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end, { desc = "[L]SP: [W]orkspace symbols" })

      -- Go to actions
      local telescope_opts = {
        layout_strategy = "vertical",
        initial_mode = "normal",
        show_line = false, -- Don't show the whole line in the picker next to the file path
      }
      map("n", "gd", function()
        require("telescope.builtin").lsp_definitions(telescope_opts)
      end, { desc = "Go to definition" })
      map("n", "gD", function()
        require("telescope.builtin").lsp_type_definitions(telescope_opts)
      end, { desc = "Go to type definition" })
      map("n", "gr", function()
        require("telescope.builtin").lsp_references(telescope_opts)
      end, { desc = "Go to references" })
      map("n", "<leader>xr", function()
        require("trouble").toggle("lsp_references")
      end, { desc = "Trouble: [R]eferences" })

      -- Navigation
      -- Define illuminate keymaps here to benefit from the "on_attach" behavior
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      local next_reference, prev_reference = ts_repeat_move.make_repeatable_move_pair(
        require("illuminate").goto_next_reference,
        require("illuminate").goto_prev_reference
      )
      map({ "n", "x", "o" }, "[r", next_reference, { desc = "Next reference" })
      map({ "n", "x", "o" }, "]r", prev_reference, { desc = "Previous reference" })
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
      lua_ls = { -- Called lua-language-server in Mason
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
