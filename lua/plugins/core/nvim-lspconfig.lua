return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  ft = function() -- `vim.g.language_servers` is not known at this stage so it can't be used
    local filetypes = {}
    for _, server in pairs(require("config.data").language_servers) do
      if server then
        for _, filetype in ipairs(server.filetypes) do
          if not vim.tbl_contains(filetypes, filetype) then
            table.insert(filetypes, filetype)
          end
        end
      end
    end
    return filetypes
  end,
  config = function()
    ---@type nvim_config.LanguageServers
    local language_servers =
      vim.tbl_deep_extend("force", require("config.data").language_servers, vim.g.language_servers or {})

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("NvimLspconfigKeymaps", { clear = true }),
      callback = function(event)
        ---@param mode string|string[]
        ---@param lhs string
        ---@param rhs string|function
        ---@param opts table
        local function map(mode, lhs, rhs, opts)
          opts.buffer = event.buf
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        map("n", "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature help" }) -- Insert-mode keymap is handled by blink.cmp
        map("n", "gd", "<cmd>Trouble lsp_definitions<CR>", { desc = "Go to definition" })
        map("n", "grt", "<cmd>Trouble lsp_type_definitions<CR>", { desc = "LSP: type definition" })
        map("n", "grd", "<cmd>Trouble lsp_declarations<CR>", { desc = "LSP: declaration" })
        map("n", "gri", "<cmd>Trouble lsp_implementations<CR>", { desc = "LSP: implementation" })
        map("n", "grr", "<cmd>Trouble lsp_references<CR>", { desc = "LSP: references" })
        map("n", "gra", vim.lsp.buf.code_action, { desc = "LSP: code actions" })
        map("n", "grn", vim.lsp.buf.rename, { desc = "LSP: rename" })
      end,
    })

    local automatic_enable = {}
    for name, language_server in pairs(language_servers) do
      if language_server then
        table.insert(automatic_enable, name)
        vim.lsp.config(name, language_server.config or {})
      end
    end
    require("mason-lspconfig").setup({ automatic_enable = automatic_enable })
  end,
}
