-- null-ls.nvim
--
-- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
-- null-ls.nvim relies on packages installed by mason.nvim and defined in the file `mason.lua`.

return {
  "nvimtools/none-ls.nvim", -- Since null-ls has been archived, use community fork
  dependencies = {
    "williamboman/mason.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
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
        null_ls.builtins.formatting.ruff_format,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.formatting.ruff, -- diagnostic fixes
        -- Other
        null_ls.builtins.formatting.prettier,
      },
      should_attach = function(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)

        local relative_name = vim.fn.fnamemodify(name, ":p:~:.")
        -- Don't attach to files outside of the workspace
        if vim.startswith(relative_name, "/") or vim.startswith(relative_name, "~") then
          return false
        -- Don't attach to files inside Python virtual environments
        elseif vim.startswith(relative_name, ".venv/") then
          return false
        end

        -- Don't attach to git-ignored files (this check could be time-consuming)
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
          vim.keymap.set("n", "<leader>lf", function()
            lsp_formatting(bufnr)
          end, { buffer = bufnr, desc = "[L]SP: [F]ormat" })
        end
      end,
    }
  end,
}
