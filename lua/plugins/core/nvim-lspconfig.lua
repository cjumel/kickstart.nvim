-- nvim-lspconfig
--
-- Plugin containing a collection of configurations for the Neovim builtin LSP client. It does not contain neither
-- the code of the Neovim LSP itself, nor the language servers implementations. It makes super easy setting up a LSP
-- in Neovim, bridging the gap between the LSP client and the language servers implementations.

-- Reformat the language server configurations to match the one expected by nvim-lspconfig
local language_servers = {}
local fts = {}
for ft, ft_language_servers in pairs(Metaconfig.language_servers_by_ft) do
  for language_server_name, language_server_config in pairs(ft_language_servers) do
    if language_server_config then
      language_servers[language_server_name] = language_server_config
      if not vim.tbl_contains(fts, ft) then
        table.insert(fts, ft)
      end
    end
  end
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  ft = fts,
  init = function()
    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    for server_name, _ in pairs(language_servers) do
      local mason_name = Metaconfig.language_server_name_to_mason_name[server_name] or server_name
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
        map("n", "gd", "<cmd>Trouble lsp_definitions<CR>", "Go to definition")
        map("n", "gD", "<cmd>Trouble lsp_type_definitions<CR>", "Go to type definition")
        map("n", "gra", vim.lsp.buf.code_action, "Code actions")
        map("n", "gri", "<cmd>Trouble lsp_implementations<CR>", "Implementations")
        map("n", "grn", vim.lsp.buf.rename, "Rename")
        map("n", "grr", "<cmd>Trouble lsp_references<CR>", "References")
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
          local server = vim.deepcopy(language_servers[server_name] or {}) -- Make sure the Metaconfig doesn't change
          -- This handles overriding only values explicitly passed by the server configuration above, which can be
          -- useful when disabling certain features of a language server
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
