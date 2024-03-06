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
    mason_ensure_installed = { -- Custom option to automatically install missing Mason packages
      "prettier",
      "ruff",
      "stylua",
    },
    formatters_by_ft = {
      json = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      python = {
        "ruff_fix", -- Fix lint diagnostics
        "ruff_format", -- Regular formatting
      },
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
        lsp_fallback = false,
        timeout_ms = 500,
      }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- Automatically install missing Mason packages similarly to mason-lspconfig
    local registry = require("mason-registry")
    local log_level = vim.log.levels.INFO
    local notify_opts = { title = "mason.nvim" }
    registry.refresh(function()
      for _, pkg_name in ipairs(opts.mason_ensure_installed) do
        local pkg = registry.get_package(pkg_name)
        if not pkg:is_installed() then
          vim.notify(('Installing "%s"'):format(pkg_name), log_level, notify_opts)
          pkg:install()
          vim.notify(('"%s" was successfully installed'):format(pkg_name), log_level, notify_opts)
        end
      end
    end)
  end,
}
