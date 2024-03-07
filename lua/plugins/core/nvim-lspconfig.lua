-- nvim-lspconfig
--
-- Configuration for the Neovim LSP client.

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "RRethy/vim-illuminate",
  },
  ft = { -- Only trigger the setup for the few file types which support a language server
    "lua",
    "python",
  },
  opts = {
    -- Define the language servers and their configuration overrides
    -- Available keys for overrides are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP
    --    features.
    --  - settings (table): Override the default settings passed when initializing the server.
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- Ignore noisy `missing-fields` warnings
            diagnostics = { disable = { "missing-fields" } },
            -- Disable LSP snippets (redundant with LuaSnip)
            completion = { keywordSnippet = "Disable" },
          },
        },
      },
      pyright = {
        capabilities = {
          -- Disable Pyright diagnostics when something is not used
          -- See https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1700845901
          textDocument = { publishDiagnostics = { tagSupport = { valueSet = { 2 } } } },
        },
      },
    },

    -- Function run when a language server is attached to a particular buffer
    -- Here we can define buffer-local keymaps which will not be enabled in buffers where no
    -- language server is attached
    on_attach = function(_, bufnr)
      local function map(mode, l, r, buffer_opts)
        buffer_opts = buffer_opts or {}
        buffer_opts.buffer = bufnr
        vim.keymap.set(mode, l, r, buffer_opts)
      end

      map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature help" })
      map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "[L]SP: [R]ename" })
      map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "[L]SP: [A]ction" })

      -- LSP symbol (variables, function, classes, etc.) search
      map("n", "<leader>ld", function()
        require("telescope.builtin").lsp_document_symbols()
      end, { desc = "[L]SP: [D]ocument symbols" })
      map("n", "<leader>lw", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end, { desc = "[L]SP: [W]orkspace symbols" })

      -- Go to navigation
      local telescope_opts = {
        initial_mode = "normal",
        layout_strategy = "vertical",
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

      -- Next/previous reference navigation
      -- Define illuminate keymaps here to benefit from the on_attach function behavior
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      local next_reference, prev_reference = ts_repeat_move.make_repeatable_move_pair(
        require("illuminate").goto_next_reference,
        require("illuminate").goto_prev_reference
      )
      map({ "n", "x", "o" }, "[r", next_reference, { desc = "Next reference" })
      map({ "n", "x", "o" }, "]r", prev_reference, { desc = "Previous reference" })
    end,
  },
  config = function(_, opts)
    -- Mason is responsible for installing and managing language servers
    -- Language servers will be automatically installed if they are missing
    require("mason").setup() -- Needs to be called before mason-lspconfig setup
    local ensure_installed = vim.tbl_keys(opts.servers or {})
    require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

    -- Neodev does a bunch of configuration to improve Neovim development, by setting up
    -- the relevant global variables (like `vim`) and making Neovim plugin's code available
    -- to lua_ls
    require("neodev").setup()

    -- LSP servers & clients are able to communicate to each other what features they support.
    -- By default, Neovim doesn't support everything that is in the LSP Specification. With
    -- nvim-cmp, Neovim has more capabilities, so we create these new capabilities to broadcast
    -- them to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

    -- Setup the language servers
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        local server = opts.servers[server_name] or {}
        -- This handles overriding only values explicitly passed by the server configuration above
        -- Useful when disabling certain features of a language server
        server.capabilities =
          vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        server.on_attach = opts.on_attach
        require("lspconfig")[server_name].setup(server)
      end,
    })
  end,
}
