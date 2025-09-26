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

    -- Create user commands to switch lint mode, between "disable", "auto" and "force" (when command is used with a
    -- bang), globally or per-buffer (the later taking precedence over the former)
    local function notify(msg) vim.notify(msg, vim.log.levels.INFO, { title = "Lint" }) end
    local function disable_lint(args)
      if args.args == "all" then
        vim.g.lint_mode = "disable"
        notify("Lint disabled globally")
      else
        vim.b.lint_mode = "disable"
        notify("Lint disabled for current buffer")
      end
      vim.diagnostic.reset() -- Discard existing diagnotics
    end
    local function enable_lint(args)
      if args.args == "all" and args.bang then
        vim.g.lint_mode = "force"
        notify("Lint enabled globally (force)")
      elseif args.args == "all" then
        vim.g.lint_mode = "auto"
        notify("Lint enabled globally (auto)")
      elseif args.bang then
        vim.b.lint_mode = "force"
        notify("Lint enabled for current buffer (force)")
      else
        vim.b.lint_mode = "auto"
        notify("Lint enabled for current buffer (auto)")
      end
    end
    local function lint_is_disabled(args)
      if args.args == "all" then
        return vim.g.lint_mode == "disable"
      else
        return vim.b.lint_mode == "disable"
      end
    end
    local function toggle_lint(args)
      if lint_is_disabled(args) then
        enable_lint(args)
      else
        disable_lint(args)
      end
    end
    local function lint_status()
      local message = "Lint global mode: "
        .. (vim.g.lint_mode or "auto")
        .. "\n"
        .. "Lint buffer mode: "
        .. (vim.b.lint_mode or "auto")
      notify(message)
    end
    vim.api.nvim_create_user_command("LintDisable", disable_lint, {
      desc = "Disable lint",
      nargs = "?", -- 0 or 1 argument
      complete = function() return { "all" } end, -- Command line autocompletion
    })
    vim.api.nvim_create_user_command("LintEnable", enable_lint, {
      desc = "Enable lint",
      bang = true,
      nargs = "?", -- 0 or 1 argument
      complete = function() return { "all" } end, -- Command line autocompletion
    })
    vim.api.nvim_create_user_command("LintToggle", toggle_lint, {
      desc = "Toggle lint",
      bang = true,
      nargs = "?", -- 0 or 1 argument
      complete = function() return { "all" } end, -- Command line autocompletion
    })
    vim.api.nvim_create_user_command("LintStatus", lint_status, {
      desc = "Show lint status",
    })
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
