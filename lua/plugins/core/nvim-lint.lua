-- nvim-lint
--
-- An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol
-- support.

return {
  "mfussenegger/nvim-lint",
  dependencies = {
    "williamboman/mason.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
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
  opts = {
    mason_ensure_installed = { -- Custom option to automatically install missing Mason packages
      "jsonlint",
      "markdownlint",
      "ruff",
      "yamllint",
    },
    linters_by_ft = {
      json = { "jsonlint" },
      markdown = { "markdownlint" },
      python = { "ruff" },
      yaml = { "yamllint" },
    },
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
  },
  config = function(_, opts)
    local ensure_installed = require("plugins.core.mason.ensure_installed")
    ensure_installed(opts.mason_ensure_installed)

    require("lint").linters_by_ft = opts.linters_by_ft
    vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "TextChanged" }, {
      callback = function()
        if opts.should_lint() then
          require("lint").try_lint()
        end
      end,
    })
  end,
}
