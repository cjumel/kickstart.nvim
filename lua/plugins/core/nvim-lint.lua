-- nvim-lint
--
-- An asynchronous linter plugin for Neovim, complementary to the built-in Language Server Protocol support. It is my
-- plugin of choice for linting, as it's very simple, easily customizable, and is very complementary with conform.nvim,
-- my formatting plugin.

-- Some file types have already a linter integrated in nvim-lspconfig:
-- - lua_ls for Lua
-- - taplo for TOML

-- Define here which linter to use for each file type
--  Keys must be simple file types, and values arrays of linters
local linters_by_ft = {
  json = { "jsonlint" }, -- Diagnostics for parsing errors
  markdown = { "markdownlint" }, -- Diagnostics for style-related issues
  python = { "ruff" }, -- Completement Pyright with style-related & various issue diagnostics
  yaml = { "yamllint" }, -- Complement yamlls with style-related diagnostics
  -- ShellCheck provides diagnostics for parsing errors & style-related issues for bash scripts
  --  It is not made for zsh, but it works fine when disabling a few rules
  zsh = { "shellcheck" },
}

-- Specify the linters which have no Mason package
local linters_without_mason_package = {}

-- Specify the name of the Mason package for linters where they differ
local linter_to_mason_name = {}

return {
  "mfussenegger/nvim-lint",
  dependencies = { "williamboman/mason.nvim" },
  ft = vim.tbl_keys(linters_by_ft),
  init = function()
    local mason_ensure_installed = {}
    for _, linters in pairs(linters_by_ft) do
      for _, linter in ipairs(linters) do
        if not vim.tbl_contains(linters_without_mason_package, linter) then
          local mason_name = linter_to_mason_name[linter] or linter
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
    linters_by_ft = linters_by_ft,
    should_lint = function() -- Custom option to enable/disable linting
      local utils = require("utils")

      return vim.g.lint_mode == "on" or (vim.g.lint_mode == "auto" and not utils.buffer.tooling_is_disabled())
    end,
  },
  config = function(_, opts)
    local lint = require("lint")

    lint.linters_by_ft = opts.linters_by_ft
    vim.api.nvim_create_autocmd({
      "BufEnter", -- Entering a buffer
      "InsertLeave", -- Leaving insert mode
      "TextChanged", -- Text is changed by pasting, deleting, etc. but not by insert mode
      "BufWritePost", -- After writing the buffer; required for some linters relying on file on disk
    }, {
      callback = function()
        if opts.should_lint() then
          lint.try_lint()
        end
      end,
    })
  end,
}
