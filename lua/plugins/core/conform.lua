-- conform.nvim
--
-- Lightweight yet powerful formatter plugin for Neovim

-- Some file types have already a formatter integrated in lspconfig:
-- - toml: taplo
-- We need to add those file types as keys in `formatters_by_ft` to trigger formatting on save

-- Define here which formatter to use for each file type
-- Keys must be simple file types, and values arrays of formatters
local formatters_by_ft = {
  gitconfig = { "trim_newlines", "trim_whitespace" },
  gitignore = { "trim_newlines", "trim_whitespace" },
  json = { "trim_newlines", "trim_whitespace" },
  lua = { "stylua" },
  make = { "trim_newlines", "trim_whitespace" },
  markdown = { "mdformat" },
  python = {
    "ruff_fix", -- Fix lint diagnostics
    "ruff_format", -- Regular formatting
  },
  sh = { "shfmt" },
  text = { "trim_newlines", "trim_whitespace" },
  tmux = { "trim_newlines", "trim_whitespace" },
  toml = {}, -- taplo in lspconfig
  vim = { "trim_newlines", "trim_whitespace" },
  yaml = { "yamlfmt", "trim_whitespace" }, -- `trim_whitespace` completes `yamlfmt`
  zsh = { "shfmt" }, -- Not actually for zsh, but in my use case it seems to work fine
}

-- Specify the formatters which have no Mason package
local formatters_without_mason_package = {
  "trim_newlines",
  "trim_whitespace",
}

-- Specify the name of the Mason package for formatters where they differ
local formatter_to_mason_name = {
  ruff_fix = "ruff",
  ruff_format = "ruff",
}

return {
  "stevearc/conform.nvim",
  dependencies = { "williamboman/mason.nvim" },
  ft = vim.tbl_keys(formatters_by_ft),
  init = function()
    local ensure_installed = {}
    for _, formatters in pairs(formatters_by_ft) do
      for _, formatter in ipairs(formatters) do
        if not vim.tbl_contains(formatters_without_mason_package, formatter) then
          local mason_name = formatter_to_mason_name[formatter] or formatter
          if not vim.tbl_contains(ensure_installed, mason_name) then
            table.insert(ensure_installed, mason_name)
          end
        end
      end
    end
    local mason_utils = require("plugins.core.mason.utils")
    mason_utils.ensure_installed(ensure_installed)
  end,
  opts = {
    formatters_by_ft = formatters_by_ft,
    format_on_save = function(_)
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
    local conform = require("conform")
    conform.setup(opts)

    -- In visual mode, this keymap doesn't work well for all formatters (only some natively support range formatting)
    vim.keymap.set({ "n", "v" }, "<leader>af", conform.format, { desc = "[A]ctions: [F]ormat buffer/selection" })
  end,
}
