-- nvim-lint
--
-- An asynchronous linter plugin for Neovim, complementary to the built-in Language Server Protocol support. It is my
-- plugin of choice for linting, as it's very simple, easily customizable, and is very complementary with conform.nvim,
-- my formatting plugin.

local nvim_config = require("nvim_config")

-- Specify the name of the Mason package corresponding to linters when they differ
local linter_to_mason_name = {}

local linters_by_ft = {}
for ft, linters in pairs(nvim_config.linters_by_ft) do
  local linter_is_disabled = (
    nvim_config.disable_lint_on_fts == "*" or vim.tbl_contains(nvim_config.disable_lint_on_fts or {}, ft)
  )
  if not linter_is_disabled then
    linters_by_ft[ft] = linters
  end
end

return {
  "mfussenegger/nvim-lint",
  cond = not nvim_config.light_mode,
  dependencies = { "williamboman/mason.nvim" },
  ft = vim.tbl_keys(linters_by_ft),
  init = function()
    local mason_ensure_installed = {}
    for _, linters in pairs(linters_by_ft) do
      for _, linter in ipairs(linters) do
        local mason_name = linter_to_mason_name[linter] or linter
        if
          not vim.tbl_contains(mason_ensure_installed, mason_name)
          and not vim.tbl_contains(vim.g.mason_ensure_installed or {}, mason_name)
        then
          table.insert(mason_ensure_installed, mason_name)
        end
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  opts = {
    linters_by_ft = linters_by_ft,
    should_lint = function() -- Custom option to enable/disable linting
      local lint_is_disabled_by_command = vim.g.disable_lint or vim.b[vim.fn.bufnr()].disable_lint
      if lint_is_disabled_by_command then
        return false
      end

      local absolute_file_path = vim.fn.expand("%:p")
      local absolute_cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
      local file_is_in_cwd = string.sub(absolute_file_path, 1, #absolute_cwd_path) == absolute_cwd_path
      if not file_is_in_cwd then
        return false
      end

      for _, path_pattern in ipairs(nvim_config.tooling_blacklist_path_patterns or {}) do
        local file_matches_tooling_blacklist_pattern = absolute_file_path:match(path_pattern)
        if file_matches_tooling_blacklist_pattern then
          return false
        end
      end

      return true
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

    -- Create command to toggle lint
    -- Used with a bang ("!"), the disable command will disable lint just for the current buffer (there's no
    -- case where the bang can be useful for the enable command)
    vim.api.nvim_create_user_command("LintDisable", function(args)
      if args.bang then
        vim.b.disable_lint = true
      else
        vim.g.disable_lint = true
      end
    end, { desc = "Disable lint", bang = true })
    vim.api.nvim_create_user_command("LintEnable", function()
      vim.b.disable_lint = false
      vim.g.disable_lint = false
    end, { desc = "Enable lint" })
    vim.api.nvim_create_user_command("LintToggle", function(args)
      if vim.b.disable_lint or vim.g.disable_lint then -- Lint is disabled
        vim.b.disable_lint = false
        vim.g.disable_lint = false
      else
        if args.bang then
          vim.b.disable_lint = true
        else
          vim.g.disable_lint = true
        end
      end
    end, { desc = "Toggle lint", bang = true })
  end,
}
