-- nvim-lspconfig
--
-- Plugin containing a collection of configurations for the Neovim builtin LSP client. It does not contain neither
-- the code of the Neovim LSP itself, nor the language servers implementations. It makes super easy setting up a LSP
-- in Neovim, bridging the gap between the LSP client and the language servers implementations.

local nvim_config = require("nvim_config")

-- In `language_servers`, define the language servers to use and their configuration overrides.
-- Available keys for overrides are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP
--    features.
--  - settings (table): Override the default settings passed when initializing the server.
-- In this implementation, filetypes must be defined for each server as it is used to setup Lazy, and it must be a
--  table of strings
local language_servers = {

  -- Provide basic language server features, like symbol navigation
  jsonls = {
    filetypes = { "json" },
  },

  -- For LuaLS detailed documentation, see: https://luals.github.io/wiki/settings/
  -- Besides regular LSP features, LuaLS provides very cool diagnostics making a linter not needed, as well as some
  --  static type checking
  -- Additional LuaLS configuration is handled by the lazydev.nvim plugin
  lua_ls = {
    filetypes = { "lua" },
    settings = {
      Lua = {
        completion = {
          -- Complete with function names instead of call snippets
          -- For a function `func` taking `a` and `b` as arguments, a call snippet is `func(a, b)` where `a` and `b`
          --  are placeholders to fill
          callSnippet = "Disable",
          -- Complete with regular keyword instead of keyword snippets
          -- Keyword snippets are snippets for keywords like `if`, `for`, `while`, etc.
          -- Custom snippets implemented with Luasnip are noticably faster, and they don't require for the LSP
          --  workspace to be loaded
          keywordSnippet = "Disable",
        },
        diagnostics = {
          disable = { "missing-fields" }, -- Ignore noisy `missing-fields` warnings
        },
      },
    },
  },

  -- Marksman provides some basic LSP features for markdown files (like LSP symbols), as well as more refined features
  --  to interact with links & references (completion, renaming, preview, etc.)
  marksman = {
    filetypes = { "markdown" },
  },

  -- Pyright provides regular LSP features, as well as static type checking, making another static type checker like
  --  mypy redundant
  pyright = {
    filetypes = { "python" },
    capabilities = {
      -- Disable noisy `variable not accessed` diagnostics
      textDocument = { publishDiagnostics = { tagSupport = { valueSet = { 2 } } } },
    },
  },

  -- Taplo provides linting, formatting and some features based on schemas from SchemaStore like validation or hovering
  taplo = {
    filetypes = { "toml" },
  },

  -- Tinymist provides many cool features for Typst, like LSP features (go to declaration, auto-completion, etc.),
  --  diagnostics, formatting with popular Typst formatters or even compiling the PDF file on save (even though I don't
  --  use this last feature, as it also compiles Typst modules which are not designed to be compiled)
  tinymist = {
    filetypes = { "typst" },
    settings = {
      formatterMode = "typstyle", -- Use Typstyle as default formatter
    },
  },

  ts_ls = {
    filetypes = { "javascript", "typescript" },
  },

  -- Provide some features based on schemas from SchemaStore like completion or hovering
  yamlls = {
    filetypes = { "yaml" },
  },
}

-- Specify the name of the Mason package corresponding to language servers when they differ
local server_name_to_mason_name = {
  jsonls = "json-lsp",
  lua_ls = "lua-language-server",
  ts_ls = "typescript-language-server",
  yamlls = "yaml-language-server",
}

return {
  "neovim/nvim-lspconfig",
  cond = not nvim_config.light_mode,
  dependencies = {
    "williamboman/mason.nvim",
    { "williamboman/mason-lspconfig.nvim", cond = not nvim_config.light_mode },
    { "hrsh7th/cmp-nvim-lsp", cond = not nvim_config.light_mode },
    "RRethy/vim-illuminate",
  },
  ft = function()
    local filetypes = {}
    for _, server in pairs(language_servers) do
      for _, filetype in ipairs(server.filetypes) do
        table.insert(filetypes, filetype)
      end
    end
    return filetypes
  end,
  init = function()
    local mason_ensure_installed = {}
    for server_name, _ in pairs(language_servers) do
      local mason_name = server_name_to_mason_name[server_name] or server_name
      if
        not vim.tbl_contains(mason_ensure_installed, mason_name)
        and not vim.tbl_contains(vim.g.mason_ensure_installed or {}, mason_name)
      then
        table.insert(mason_ensure_installed, mason_name)
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  config = function()
    -- Define a callback run each time when a language server is attached to a particular buffer where we can define
    --  buffer-local keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("NvimLspconfigKeymaps", { clear = true }),
      callback = function(event)
        ---@param mode string|string[] The mode(s) of the keymap.
        ---@param lhs string The left-hand side of the keymap.
        ---@param rhs string|function The right-hand side of the keymap.
        ---@param desc string The description of the keymap.
        ---@param opts table|nil Additional options for the keymap.
        local function map(mode, lhs, rhs, desc, opts)
          opts = opts or {}
          opts.desc = desc
          opts.buffer = event.buf
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "gd", "<cmd>Trouble lsp_definitions<CR>", "Go to definitions")
        map("n", "gD", "<cmd>Trouble lsp_type_definitions<CR>", "Go to type definitions")
        map("n", "gra", vim.lsp.buf.code_action, "Code action")
        map("n", "grn", vim.lsp.buf.rename, "Rename")
        map("n", "grr", "<cmd>Trouble lsp_references<CR>", "References")

        -- Symbols keymaps
        local telescope_builtin = require("plugins.core.telescope.builtin")
        map({ "n", "v" }, "<leader>fs", telescope_builtin.lsp_document_symbols, "[F]ind: [S]ymbols (document)")
        map({ "n", "v" }, "<leader>fw", telescope_builtin.lsp_workspace_symbols, "[F]ind: [W]orkspace symbols")

        -- Next/previous reference navigation; let's define illuminate keymaps here to benefit from the "LspAttach"
        --  behavior. Besides, the "LspAttach" event is triggered after "BufReadPre", hence nvim-treesitter-textobjects
        --  is already loaded at this point.
        local ts_keymap = require("plugins.core.nvim-treesitter-textobjects.keymap")
        ts_keymap.set_local_move_pair(
          "r",
          function() require("illuminate").goto_next_reference() end,
          function() require("illuminate").goto_prev_reference() end,
          "reference"
        )
      end,
    })

    -- LSP servers & clients (Neovim's) are able to communicate to each other what features they support. By default,
    --  Neovim doesn't support everything that is in the LSP Specification. With nvim-cmp, Neovim has more capabilities,
    --  so we create these new capabilities to broadcast them to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

    -- Make sure the language servers are installed and set them up. Mason is responsible for installing and managing
    --  language servers, so it must be setup before mason-lspconfig.
    require("mason").setup()
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = language_servers[server_name] or {}
          -- This handles overriding only values explicitly passed by the server configuration above, which can be
          --  useful when disabling certain features of a language server
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
