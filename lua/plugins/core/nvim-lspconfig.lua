-- nvim-lspconfig
--
-- Plugin containing a collection of configurations for the Neovim builtin LSP client. It does not contain neither
-- the code of the Neovim LSP itself, nor the language servers implementations. It makes super easy setting up a LSP
-- in Neovim, bridging the gap between the LSP client and the language servers implementations.

-- Specify the name of the Mason package corresponding to language servers when they differ
local server_name_to_mason_name = {
  jsonls = "json-lsp",
  lua_ls = "lua-language-server",
  rust_analyzer = "rust-analyzer",
  ts_ls = "typescript-language-server",
  yamlls = "yaml-language-server",
}

local fts = {}
for _, server in pairs(Metaconfig.language_servers or {}) do
  for _, filetype in ipairs(server.filetypes) do
    table.insert(fts, filetype)
  end
end

return {
  "neovim/nvim-lspconfig",
  cond = not Metaconfig.light_mode,
  dependencies = {
    "williamboman/mason.nvim",
    { "williamboman/mason-lspconfig.nvim", cond = not Metaconfig.light_mode },
    { "hrsh7th/cmp-nvim-lsp", cond = not Metaconfig.light_mode },
  },
  ft = fts,
  init = function()
    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    for server_name, _ in pairs(Metaconfig.language_servers or {}) do
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
    -- buffer-local keymaps
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
        local telescope_pickers = require("plugins.core.telescope.pickers")
        map({ "n", "v" }, "<leader>fs", telescope_pickers.lsp_document_symbols, "[F]ind: buffer [S]ymbols")
        map({ "n", "v" }, "<leader>fS", telescope_pickers.lsp_workspace_symbols, "[F]ind: workspace [S]ymbols")

        -- Next/previous reference navigation; let's define these keymaps here to benefit from the "LspAttach" behavior
        -- (nvim-treesitter-textobjects is already loaded at this point)
        local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
        local forward_move_fn, backward_move_fn = ts_repeatable_move.make_repeatable_move_pair(
          function() require("snacks").words.jump(vim.v.count1, true) end,
          function() require("snacks").words.jump(-vim.v.count1, true) end
        )
        map({ "n", "x", "o" }, "[[", forward_move_fn, "Next reference")
        map({ "n", "x", "o" }, "]]", backward_move_fn, "Previous reference")
      end,
    })

    -- LSP servers & clients (Neovim) are able to communicate to each other what features they support. By default,
    -- Neovim doesn't support everything that is in the LSP Specification. With nvim-cmp, Neovim has more capabilities,
    -- so we create these new capabilities to broadcast them to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

    -- Make sure the language servers are installed and set them up. Mason is responsible for installing and managing
    -- language servers, so it must be setup before mason-lspconfig.
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = vim.deepcopy(Metaconfig.language_servers[server_name] or {}) -- Avoid updating the conf table later
          -- This handles overriding only values explicitly passed by the server configuration above, which can be
          -- useful when disabling certain features of a language server
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
