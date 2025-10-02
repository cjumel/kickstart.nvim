local linters_by_ft = {}
for ft, linters in pairs(MetaConfig.linters_by_ft or {}) do
  if linters then
    linters_by_ft[ft] = linters
  end
end

return {
  "mfussenegger/nvim-lint",
  dependencies = { "mason-org/mason.nvim" },
  ft = vim.tbl_keys(linters_by_ft),
  init = function()
    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    for _, linters in pairs(linters_by_ft) do
      for _, mason_name in ipairs(linters) do
        table.insert(mason_ensure_installed, mason_name)
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  opts = {
    linters_by_ft = linters_by_ft,
    should_lint = function() -- Custom option to enable/disable linting
      local bufnr = vim.fn.bufnr()

      local lint_is_enabled_by_command = vim.b[bufnr].lint_mode == "force"
        or (vim.g.lint_mode == "force" and (vim.b[bufnr].lint_mode or "auto") == "auto")
      if lint_is_enabled_by_command then
        return true
      end
      local lint_is_disabled_by_command = vim.b[bufnr].lint_mode == "disable"
        or (vim.g.lint_mode == "disable" and (vim.b[bufnr].lint_mode or "auto") == "auto")
      if lint_is_disabled_by_command then
        return false
      end

      local absolute_file_path = vim.fn.expand("%:p")
      local absolute_cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
      local file_is_in_cwd = string.sub(absolute_file_path, 1, #absolute_cwd_path) == absolute_cwd_path
      if not file_is_in_cwd then
        return false
      end

      local relative_file_path = vim.fn.expand("%:p:~")
      local excluded_file_patterns =
        vim.list_extend(MetaConfig.disable_lint_on_files or {}, MetaConfig.disable_tooling_on_files or {})
      for _, excluded_file_pattern in ipairs(excluded_file_patterns) do
        local file_is_excluded = relative_file_path:match(excluded_file_pattern)
        if file_is_excluded then
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
  end,
}
