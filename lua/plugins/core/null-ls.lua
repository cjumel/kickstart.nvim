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
    local null_ls = require("null-ls")

    return {
      border = "rounded", -- Adding a border is lot better for transparent background
      sources = {
        -- Python
        null_ls.builtins.diagnostics.ruff,
      },
      should_attach = function(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        -- Don't attach to Oil buffers
        if vim.startswith(name, "oil://") then
          return false
        end

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
    }
  end,
}
