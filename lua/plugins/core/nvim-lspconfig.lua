-- nvim-lspconfig
--
-- Plugin containing a collection of configurations for the Neovim builtin LSP client. It does not contain neither
-- the code of the Neovim LSP itself, nor the language servers implementations. It makes super easy setting up a LSP
-- in Neovim, bridging the gap between the LSP client and the language servers implementations.

-- Define the language servers and their configuration overrides
-- Available keys for overrides are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP
--    features.
--  - settings (table): Override the default settings passed when initializing the server.
-- In this implementation, filetypes must be defined for each server as it is used to setup Lazy, and it must be a
--  table of strings
local servers = {

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

  -- Yamlls provides some features based on schemas from SchemaStore like completion or hovering
  yamlls = {
    filetypes = { "yaml" },
  },
}

local server_name_to_mason_name = { -- This is usually done in mason-lspconfig
  lua_ls = "lua-language-server",
  yamlls = "yaml-language-server",
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
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
  init = function()
    local mason_ensure_installed = {}
    for server_name, _ in pairs(servers) do
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
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local illuminate = require("illuminate")
        local telescope = require("telescope.builtin")
        local telescope_custom = require("plugins.core.telescope.builtin")
        local utils = require("utils")

        local bufnr = event.bufnr
        local map = utils.keymap.get_buffer_local_map(bufnr)

        local go_to_opts = {
          initial_mode = "normal",
          show_line = false, -- Don't show the whole line in the picker next to the file path
        }

        map("n", "<C-s>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "gra", vim.lsp.buf.code_action, "Code action")
        map("n", "grn", function() return ":IncRename " .. vim.fn.expand("<cword>") end, "Rename", { expr = true })
        map("n", "grr", function() telescope.lsp_references(go_to_opts) end, "Go to references")
        map("n", "grx", "<cmd>LspRestart<CR>", "Restart LSP")
        map("n", "grs", telescope_custom.lsp_document_symbols, "Symbols")
        map("n", "grw", telescope_custom.lsp_workspace_symbols, "Workspace symbols")

        -- Neovim has default keymaps for "go to definition" with gd and "go to declaration" with gD written for the C
        --  language, let's overwrite them; Telescope has a "go to implementation" feature, but I don't use languages
        --  where this is useful
        map("n", "gd", function() telescope.lsp_definitions(go_to_opts) end, "Go to definition")
        map("n", "gD", function() telescope.lsp_type_definitions(go_to_opts) end, "Go to type definition")

        -- Next/previous reference navigation; let's define illuminate keymaps here to benefit from the "LspAttach"
        --  behavior
        utils.keymap.set_move_pair({ "[r", "]r" }, {
          illuminate.goto_next_reference,
          illuminate.goto_prev_reference,
        }, {
          { desc = "Next reference", buffer = bufnr },
          { desc = "Previous reference", buffer = bufnr },
        })
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
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed by the server configuration above, which can be
          --  useful when disabling certain features of a language server
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
