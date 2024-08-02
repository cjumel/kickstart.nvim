-- conform.nvim
--
-- Lightweight yet powerful formatter plugin for Neovim. This is my plugin of choice for formatting & auto-formatting
-- due to its great flexibility & customizability while still remaining quite simple, compared to alternative like
-- null-ls/none-ls.

-- Define here which formatters to use for each file type
--  Keys must be simple file types, and values arrays of formatter names
-- In some file types, a formatter is integrated as a language server in `nvim-lspconfig`; in that case, the
--  corresponding file type must be added as a key with an empty array as value, to trigger formatting on save
local formatters_by_ft = {
  gitconfig = { "trim_newlines", "trim_whitespace" },
  gitignore = { "trim_newlines", "trim_whitespace" },
  json = { "trim_newlines", "trim_whitespace" },
  lua = { "stylua" },
  make = { "trim_newlines", "trim_whitespace" },
  markdown = { "mdformat" },
  python = { "ruff_fix", "ruff_format" }, -- Lint diagnostic automatic fixes & regular formatting
  sh = { "shfmt" },
  text = { "trim_newlines", "trim_whitespace" },
  tmux = { "trim_newlines", "trim_whitespace" },
  toml = {}, -- taplo in lspconfig
  vim = { "trim_newlines", "trim_whitespace" },
  yaml = { "yamlfmt", "trim_whitespace" }, -- "trim_whitespace" completes "yamlfmt"
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
    -- Enable conform formatting with Neovim's builtin formatting (see `:h gq`)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    local mason_ensure_installed = {}
    for _, formatters in pairs(formatters_by_ft) do
      for _, formatter in ipairs(formatters) do
        if not vim.tbl_contains(formatters_without_mason_package, formatter) then
          local mason_name = formatter_to_mason_name[formatter] or formatter
          if
            not vim.tbl_contains(mason_ensure_installed, mason_name)
            and not vim.tbl_contains(vim.g.mason_ensure_installed or {}, mason_name)
          then
            table.insert(mason_ensure_installed, mason_name)
          end
        end
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  opts = {
    formatters_by_ft = formatters_by_ft,
    format_on_save = function(_)
      local utils = require("utils")

      if
        vim.g.format_on_save_mode == "on"
        or (vim.g.format_on_save_mode == "auto" and not utils.buffer.tooling_is_disabled())
      then
        return { lsp_fallback = true, timeout_ms = 500 }
      end
    end,
  },
}
