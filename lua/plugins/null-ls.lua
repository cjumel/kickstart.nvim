-- null-ls.nvim
--
-- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
-- null-ls.nvim relies on packages installed by mason.nvim and defined in the file `mason.lua`.

return {
  'jose-elias-alvarez/null-ls.nvim',
  ft = {
    -- Lua
    'lua',
    -- Python
    'python',
    -- Other
    'json',
    'markdown',
    'yaml',
  },
  opts = function()
    local null_ls = require 'null-ls'
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    return {
      sources = {
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- Python
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.diagnostics.mypy.with {
          extra_args = function()
            local virtual = os.getenv 'VIRTUAL_ENV' or '/usr'
            return { '--python-executable', virtual .. '/bin/python3' }
          end,
        },
        -- Other
        null_ls.builtins.formatting.prettier,
      },
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds {
            group = augroup,
            buffer = bufnr,
          }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr }
            end,
          })
        end
      end,
    }
  end,
}
