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
          vim.notify("Format on save disabled.")
          vim.g.disable_autoformat = true
        else
          vim.notify("Format on save enabled.")
          vim.g.disable_autoformat = false
        end
      end,
      desc = "Settings: toggle [F]ormat on save",
    },
  },
  opts = {
    mason_ensure_installed = { -- Custom option to automatically install missing Mason packages
      "prettier",
      "ruff",
      "stylua",
      "taplo",
    },
    formatters_by_ft = {
      json = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      python = {
        "ruff_fix", -- Fix lint diagnostics
        "ruff_format", -- Regular formatting
      },
      toml = { "taplo" },
      yaml = { "prettier" },
      ["_"] = { -- Files with no other formatter configured
        "trim_newlines",
        "trim_whitespace",
      },
    },
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
        lsp_fallback = true, -- Some formatters (like taplo) are setup with lspconfig
        timeout_ms = 500,
      }
    end,
  },
  config = function(_, opts)
    local ensure_installed = require("plugins.core.mason.ensure_installed")
    ensure_installed(opts.mason_ensure_installed)

    require("conform").setup(opts)
  end,
}
