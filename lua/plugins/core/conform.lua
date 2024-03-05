-- conform.nvim
--
-- Lightweight yet powerful formatter plugin for Neovim

return {
  "stevearc/conform.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>,f",
      function()
        if not vim.g.disable_autoformat then
          vim.g.disable_autoformat = true
        else
          vim.g.disable_autoformat = false
        end
      end,
      desc = "Settings: toggle [F]ormat on save",
    },
    {
      "<leader>cf",
      function()
        require("conform").format()
      end,
      desc = "[C]ode: [F]ormat",
    },
  },
  opts = {
    formatters_by_ft = {},
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { "oil" }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end

      -- Disable with a global variable
      if vim.g.disable_autoformat then
        return
      end

      return {
        lsp_fallback = false,
        timeout_ms = 500,
      }
    end,
  },
}
