-- nvim-lspconfig
--
-- Configuration for the Neovim LSP client.

-- Define the language servers and their configuration overrides
-- Available keys for overrides are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP
--    features.
--  - settings (table): Override the default settings passed when initializing the server.
-- In this implementation, filetypes must be defined for each server as it is used to setup Lazy,
-- and it must be a table of strings
local servers = {

  -- A lot of lua_ls's configuration is handled through neodev's setup (see below)
  -- For lua_ls detailed documentation, see: https://luals.github.io/wiki/settings/
  -- Besides regular LSP features, lua_ls provides very cool diagnostics making a linter (like
  -- Selene) redundant, as well as some static type checking
  lua_ls = {
    filetypes = { "lua" },
    settings = {
      Lua = {
        completion = {
          -- For a function `func` taking `a` and `b` as arguments, a call snippet is `func(a, b)`
          -- where `a` and `b` are placeholders to fill
          callSnippet = "Disable", -- Complete with function names, not call snippets (default)
          -- Keyword snippets are snippets for keywords like `if`, `for`, `while`, etc.
          -- Custom snippets implemented with Luasnip are noticably faster, and they don't
          -- require for the LSP workspace to be loaded
          keywordSnippet = "Disable", -- Complete with regular keyword, not keyword snippets
        },
        diagnostics = {
          disable = { "missing-fields" }, -- Ignore noisy `missing-fields` warnings
        },
      },
    },
  },

  -- Marksman provides some basic LSP features for markdown files (like LSP symbols), as well as more refined features
  -- to interact with links & references (completion, renaming, preview, etc.)
  marksman = {
    filetypes = { "markdown" },
  },

  -- Besides regular LSP features, pyright provides static type checking making another
  -- static type checker (like mypy) redundant
  -- Ruff-lsp can be implemented as additional language server to Pyright to provide
  -- formatting, linting and contextual code actions, but I was not able to make it work like
  -- the currrent setup through nvim-lint and conform.nvim
  pyright = {
    filetypes = { "python" },
    capabilities = {
      -- Disable noisy `variable not accessed` diagnostics
      textDocument = { publishDiagnostics = { tagSupport = { valueSet = { 2 } } } },
    },
  },

  -- Taplo provides linting, formatting and some features based on schemas from SchemaStore like
  -- validation or hovering
  taplo = {
    filetypes = { "toml" },
  },

  -- yamlls provides some features based on schemas from SchemaStore like completion or hovering
  yamlls = {
    filetypes = { "yaml" },
  },
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "nvim-telescope/telescope.nvim",
    "RRethy/vim-illuminate",
    "ray-x/lsp_signature.nvim",
    "smjonas/inc-rename.nvim",
  },
  ft = function()
    local filetypes = {}
    for _, server in pairs(servers) do
      for _, filetype in ipairs(server.filetypes) do
        table.insert(filetypes, filetype)
      end
    end
    return filetypes
  end,
  opts = {
    servers = servers,

    -- Function run when a language server is attached to a particular buffer
    -- Here we can define buffer-local keymaps which will not be enabled in buffers where no
    -- language server is attached
    on_attach = function(_, bufnr)
      local illuminate = require("illuminate")
      local telescope = require("telescope.builtin")

      local utils = require("utils")

      local map = utils.keymap.get_buffer_local_map(bufnr)

      map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help")
      map("n", "crr", vim.lsp.buf.code_action, "Code action")
      map("n", "crn", function() return ":IncRename " .. vim.fn.expand("<cword>") end, "Rename", { expr = true })
      map("n", "<leader>ls", function() vim.cmd("LspRestart") end, "[L]SP: [S]tart again")

      -- LSP symbol (variables, function, classes, etc.) search
      map("n", "<leader>ld", telescope.lsp_document_symbols, "[L]SP: [D]ocument symbols")
      map("n", "<leader>lw", telescope.lsp_dynamic_workspace_symbols, "[L]SP: [W]orkspace symbols")

      -- Go to navigation
      local opts = {
        initial_mode = "normal",
        show_line = false, -- Don't show the whole line in the picker next to the file path
      }
      map("n", "gd", function() telescope.lsp_definitions(opts) end, "Go to definition")
      map("n", "gD", function() telescope.lsp_type_definitions(opts) end, "Go to type definition")
      map("n", "gr", function() telescope.lsp_references(opts) end, "Go to reference")
      map("n", "gR", function() require("trouble").toggle("lsp_references") end, "Open references")

      -- Next/previous reference navigation
      -- Define illuminate keymaps here to benefit from the on_attach function behavior
      utils.keymap.set_move_pair({ "[r", "]r" }, {
        illuminate.goto_next_reference,
        illuminate.goto_prev_reference,
      }, {
        { desc = "Next reference", buffer = bufnr },
        { desc = "Previous reference", buffer = bufnr },
      })
    end,
  },
  config = function(_, opts)
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

    -- Make sure the language servers are installed and set them up
    -- Mason is responsible for installing and managing language servers and it must be setup
    -- before mason-lspconfig
    -- In my configuration, this is ensured by the fact that mason is in the dependencies and
    -- mason's setup is called in the plugin configuration
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(opts.servers or {}),
      handlers = {
        function(server_name)
          local server = opts.servers[server_name] or {}
          -- This handles overriding only values explicitly passed by the server configuration above
          -- Useful when disabling certain features of a language server
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          server.on_attach = opts.on_attach
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
