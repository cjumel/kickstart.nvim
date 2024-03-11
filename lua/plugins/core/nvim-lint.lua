-- nvim-lint
--
-- An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol
-- support.

-- Some file types have already a linter integrated in lspconfig:
-- - lua: lua_ls
-- - toml: taplo

-- Define here which linter to use for each file type
-- Keys must be simple file types, and values arrays of linters
local linters_by_ft = {
  json = { "jsonlint" },
  python = { "ruff" },
  yaml = { "yamllint" },
}

-- Specify the linters which have no Mason package
local linters_without_mason_package = {}

-- Specify the name of the Mason package for linters where they differ
local linter_to_mason_name = {}

return {
  "mfussenegger/nvim-lint",
  dependencies = {
    "williamboman/mason.nvim",
  },
  ft = vim.tbl_keys(linters_by_ft),
  keys = {
    {
      "<leader>,l",
      function()
        if not vim.g.disable_lint then
          vim.g.disable_lint = true
          vim.diagnostic.reset() -- Remove existing diagnostics
          vim.notify("Lint disabled.")
        else
          vim.g.disable_lint = false
          require("lint").try_lint() -- Manually trigger linting
          vim.notify("Lint enabled.")
        end
      end,
      desc = "Settings: toggle [L]int",
    },
  },
  opts = function()
    local mason_ensure_installed = {}
    for _, linters in pairs(linters_by_ft) do
      for _, linter in ipairs(linters) do
        if not vim.tbl_contains(linters_without_mason_package, linter) then
          local mason_name = linter_to_mason_name[linter] or linter
          if not vim.tbl_contains(mason_ensure_installed, mason_name) then
            table.insert(mason_ensure_installed, mason_name)
          end
        end
      end
    end

    return {
      -- Custom option to automatically install missing Mason packages
      mason_ensure_installed = mason_ensure_installed,
      linters_by_ft = linters_by_ft,
      should_lint = function() -- Custom option to enable/disable linting
        if vim.g.disable_lint then
          return false
        end

        local path = require("utils").path.get_current_file_path()
        if path == nil then
          return false
        end

        -- Files outside of the current working directory
        if vim.startswith(path, "/") or vim.startswith(path, "~") then
          return false

        -- Files inside Python virtual environments
        elseif vim.startswith(path, ".venv/") then
          return false
        end

        return true
      end,
    }
  end,
  config = function(_, opts)
    local ensure_installed = require("plugins.core.mason.ensure_installed")
    ensure_installed(opts.mason_ensure_installed)

    require("lint").linters_by_ft = opts.linters_by_ft
    vim.api.nvim_create_autocmd({
      "BufEnter",
      "BufReadPost",
      "InsertLeave",
      "TextChanged",
    }, {
      callback = function()
        if opts.should_lint() then
          require("lint").try_lint()
        end
      end,
    })
  end,
}
