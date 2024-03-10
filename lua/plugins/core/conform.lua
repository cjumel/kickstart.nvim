-- conform.nvim
--
-- Lightweight yet powerful formatter plugin for Neovim

-- Some file types have already a formatter integrated in lspconfig:
-- - toml: taplo

-- Define here which formatter to use for each file type
-- Keys must be simple file types, and values arrays of formatters
local formatters_by_ft = {
  gitconfig = { "trim_newlines", "trim_whitespace" },
  gitignore = { "trim_newlines", "trim_whitespace" },
  json = { "trim_newlines", "trim_whitespace" },
  lua = { "stylua" },
  make = { "trim_newlines", "trim_whitespace" },
  markdown = { "mdformat" },
  norg = { "trim_newlines", "trim_whitespace" },
  python = {
    "ruff_fix", -- Fix lint diagnostics
    "ruff_format", -- Regular formatting
  },
  sh = { "shfmt" },
  text = { "trim_newlines", "trim_whitespace" },
  tmux = { "trim_newlines", "trim_whitespace" },
  yaml = { "yamlfmt" },
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
  dependencies = {
    "williamboman/mason.nvim",
  },
  ft = vim.tbl_keys(formatters_by_ft),
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
  opts = function()
    local mason_ensure_installed = {}
    for _, formatters in pairs(formatters_by_ft) do
      for _, formatter in ipairs(formatters) do
        if not vim.tbl_contains(formatters_without_mason_package, formatter) then
          local mason_name = formatter_to_mason_name[formatter] or formatter
          if not vim.tbl_contains(mason_ensure_installed, mason_name) then
            table.insert(mason_ensure_installed, mason_name)
          end
        end
      end
    end

    return {
      -- Custom option to automatically install missing Mason packages
      mason_ensure_installed = mason_ensure_installed,
      formatters_by_ft = formatters_by_ft,
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
    }
  end,
  config = function(_, opts)
    local ensure_installed = require("plugins.core.mason.ensure_installed")
    ensure_installed(opts.mason_ensure_installed)

    require("conform").setup(opts)
  end,
}
