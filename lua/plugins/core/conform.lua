-- conform.nvim
--
-- Lightweight yet powerful formatter plugin for Neovim. This is my plugin of choice for formatting & auto-formatting
-- due to its great flexibility & customizability while still remaining quite simple, compared to alternative like
-- null-ls/none-ls.

-- Define here which formatters to use for each file type
-- Keys must be simple file types, and values arrays of formatter names
-- In some file types, a formatter is alraedy integrated as a language server in `nvim-lspconfig`; in that case, the
-- corresponding file type must be added as a key with an empty array as value, to trigger formatting on save
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
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.tbl_contains(vim.g.disable_autoformat_bufnrs or {}, bufnr) then
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
    local utils = require("utils")

    conform.setup(opts)

    vim.keymap.set({ "n", "v" }, "<leader>af", function()
      if utils.visual.is_visual_mode() then
        conform.format() -- This doesn't work super well for all formatters
      else -- Following code is taken from https://github.com/stevearc/conform.nvim/issues/92#issuecomment-2069915330
        local hunks = require("gitsigns").get_hunks()
        for i = #hunks, 1, -1 do
          local hunk = hunks[i]
          if hunk ~= nil and hunk.type ~= "delete" then
            local start = hunk.added.start
            local last = start + hunk.added.count
            -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
            local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
            local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
            conform.format({ range = range })
          end
        end
      end
    end, { desc = "[A]ctions: [F]ormat changes/selection" })
    vim.keymap.set("n", "<leader>aF", conform.format, { desc = "[A]ctions: [F]ormat buffer" })
  end,
}
