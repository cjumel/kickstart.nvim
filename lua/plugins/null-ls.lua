-- null-ls.nvim
--
-- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
-- null-ls.nvim relies on packages installed by mason.nvim and defined in the file `mason.lua`.

return {
  "jose-elias-alvarez/null-ls.nvim",
  ft = {
    -- Lua
    "lua",
    -- Python
    "python",
    -- Other
    "json",
    "markdown",
    "yaml",
  },
  opts = function()
    local lsp_formatting = function(bufnr)
      vim.lsp.buf.format({
        filter = function(client)
          -- Enable only null-ls formatting, not other LSPs
          return client.name == "null-ls"
        end,
        bufnr = bufnr,
      })
    end

    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    return {
      sources = {
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- Python
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.diagnostics.mypy.with({
          extra_args = function()
            local virtual = os.getenv("VIRTUAL_ENV") or "/usr"
            return { "--ignore-missing-imports", "--python-executable", virtual .. "/bin/python3" }
          end,
        }),
        -- Other
        null_ls.builtins.formatting.prettier,
      },
      should_attach = function(bufnr)
        -- Don't attach null-ls to files in /usr/local
        if vim.startswith(vim.api.nvim_buf_get_name(bufnr), "/usr/local") then
          return false
        end

        -- Don't attach null-ls to git-ignored files (this check could be time-consuming)
        local name = vim.api.nvim_buf_get_name(bufnr)
        local dir = vim.fs.dirname(name)
        local filename = vim.fs.basename(name)
        local command = string.format("git -C %s check-ignore %s", dir, filename)
        local output = vim.fn.trim(vim.fn.system(command))
        if output == filename then
          return false
        end

        return true
      end,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({
            group = augroup,
            buffer = bufnr,
          })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              lsp_formatting(bufnr)
            end,
          })
        end
      end,
    }
  end,
}
