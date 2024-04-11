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
      local map = utils.keymap.map
      local nmap = utils.keymap.nmap
      local mpmap = utils.keymap.mpmap

      local opts = { buffer = bufnr }

      map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help", opts)
      nmap("<leader>lr", vim.lsp.buf.rename, "[L]SP: [R]ename", opts)
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode: [A]ction", opts)

      -- LSP symbol (variables, function, classes, etc.) search
      nmap("<leader>ld", telescope.lsp_document_symbols, "[L]SP: [D]ocument symbols", opts)
      nmap(
        "<leader>lw",
        telescope.lsp_dynamic_workspace_symbols,
        "[L]SP: [W]orkspace symbols",
        opts
      )

      -- Go to navigation
      local telescope_opts = {
        initial_mode = "normal",
        show_line = false, -- Don't show the whole line in the picker next to the file path
      }
      nmap("gd", function() telescope.lsp_definitions(telescope_opts) end, "Go to definition", opts)
      nmap(
        "gD",
        function() telescope.lsp_type_definitions(telescope_opts) end,
        "Go to type definition",
        opts
      )
      nmap("gr", function() telescope.lsp_references(telescope_opts) end, "Go to references", opts)

      -- Next/previous reference navigation
      -- Define illuminate keymaps here to benefit from the on_attach function behavior
      mpmap({ "[r", "]r" }, {
        illuminate.goto_next_reference,
        illuminate.goto_prev_reference,
      }, { "Next reference", "Previous reference" }, opts)
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
          server.capabilities =
            vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          server.on_attach = opts.on_attach
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
