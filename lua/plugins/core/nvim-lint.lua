local default_linters_by_ft = {
  markdown = { "markdownlint" },
  sh = { "shellcheck" },
  yaml = { "yamllint" },
  zsh = { "shellcheck" }, -- Not actually for zsh, but works fine for me
}

local default_linter_to_mason_name = {}

local default_disable_lint_on_files = {
  -- Directories inside projects but managed by external tools
  "/%.git/",
  "/%.venv",

  -- Global directories managed by package managers
  "^~/%.tmux/",
  "^~/%.local/share/nvim/",
}

return {
  "mfussenegger/nvim-lint",
  dependencies = { "mason-org/mason.nvim" },
  ft = vim.tbl_keys(default_linters_by_ft), -- `vim.g.linters_by_ft` is not known at this time
  opts = function()
    return {
      linters_by_ft = vim.tbl_deep_extend("force", default_linters_by_ft, vim.g.linters_by_ft or {}),
      should_lint = function() -- Custom option to enable/disable linting
        local lint_is_disabled_by_config = (
          vim.g.disable_lint_on_fts == "*"
          or vim.tbl_contains(vim.g.disable_lint_on_fts or {}, vim.bo.filetype)
        )
        if lint_is_disabled_by_config then
          return false
        end

        local absolute_file_path = vim.fn.expand("%:p")
        local absolute_cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
        local file_is_in_cwd = string.sub(absolute_file_path, 1, #absolute_cwd_path) == absolute_cwd_path
        if not file_is_in_cwd then
          return false
        end

        local relative_file_path = vim.fn.expand("%:p:~")
        for _, excluded_file_pattern in
          ipairs(vim.list_extend(default_disable_lint_on_files, vim.g.disable_lint_on_files or {}))
        do
          local file_is_excluded = relative_file_path:match(excluded_file_pattern)
          if file_is_excluded then
            return false
          end
        end

        return true
      end,
    }
  end,
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

    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    local linters_by_ft = vim.tbl_deep_extend("force", default_linters_by_ft, vim.g.linters_by_ft or {})
    local linter_to_mason_name =
      vim.tbl_deep_extend("force", default_linter_to_mason_name, vim.g.linter_to_mason_name or {})
    for _, linters in pairs(linters_by_ft) do
      for _, linter in ipairs(linters) do
        if linter_to_mason_name[linter] ~= false then
          local mason_name = linter_to_mason_name[linter] or linter
          table.insert(mason_ensure_installed, mason_name)
        end
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
}
