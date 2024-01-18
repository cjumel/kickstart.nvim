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
      -- Documentation
      vim.keymap.set("n", "K", function()
        -- If the cursor is on a folded line, peek the lines under the cursor
        local winid
        if require("ufo.preview.floatwin").winid ~= nil then -- Peek window is already opened
          winid = require("ufo").peekFoldedLinesUnderCursor(
            true, -- Enter in peek window
            false -- Don't show line after peek
          )
        else
          winid = require("ufo").peekFoldedLinesUnderCursor(
            false, -- Don't enter in peek window
            false -- Don't show line after peek
          )
        end
        -- Otherwise, show the hover documentation
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { buffer = bufnr, desc = "Hover" })
      vim.keymap.set(
        { "n", "i" },
        "<C-s>",
        vim.lsp.buf.signature_help,
        { buffer = bufnr, desc = "Signature help" }
      )

      -- Code edition
      vim.keymap.set("n", "<leader>lf", function()
        vim.lsp.buf.format({
          filter = function(client)
            -- Enable only null-ls formatting, not other LSPs
            return client.name == "null-ls"
          end,
          bufnr = bufnr,
        })
      end, { buffer = bufnr, desc = "[L]SP: [F]ormat" })
      vim.keymap.set(
        "n",
        "<leader>lr",
        vim.lsp.buf.rename,
        { buffer = bufnr, desc = "[L]SP: [R]ename" }
      )
      vim.keymap.set(
        "n",
        "<leader>la",
        vim.lsp.buf.code_action,
        { buffer = bufnr, desc = "[L]SP: [A]ction" }
      )

      -- Code search
      vim.keymap.set("n", "<leader>ld", function()
        require("telescope.builtin").lsp_document_symbols()
      end, { buffer = bufnr, desc = "[L]SP: [D]ocument symbols" })
      vim.keymap.set("n", "<leader>lw", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end, { buffer = bufnr, desc = "[L]SP: [W]orkspace symbols" })

      -- Go to actions
      local telescope_opts = {
        layout_strategy = "vertical",
        initial_mode = "normal",
        show_line = false, -- Don't show the whole line in the picker next to the file path
      }
      vim.keymap.set("n", "gd", function()
        require("telescope.builtin").lsp_definitions(telescope_opts)
      end, { buffer = bufnr, desc = "Go to definition" })
      vim.keymap.set("n", "gD", function()
        require("telescope.builtin").lsp_type_definitions(telescope_opts)
      end, { buffer = bufnr, desc = "Go to type definition" })
      vim.keymap.set("n", "gr", function()
        require("telescope.builtin").lsp_references(telescope_opts)
      end, { buffer = bufnr, desc = "Go to references" })
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
