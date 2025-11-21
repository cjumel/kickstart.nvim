local formatters_by_ft = {}
for ft, formatters in pairs(MetaConfig.formatters_by_ft or {}) do
  if formatters then
    formatters_by_ft[ft] = formatters
  end
end

return {
  "stevearc/conform.nvim",
  dependencies = { "mason-org/mason.nvim" },
  cmd = { "AutoformatEnable", "AutoformatDisable", "AutoformatToggle" },
  ft = vim.tbl_keys(formatters_by_ft),
  init = function()
    -- Enable conform formatting with Neovim's builtin formatting (see `:h gq`)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    -- Make sure all required dependencies can be installed with the `MasonInstallAll` command
    local mason_ensure_installed = {}
    for _, formatters in pairs(formatters_by_ft) do
      for formatter_key, formatter in ipairs(formatters) do
        if
          formatter_key ~= "lsp_format" -- "lsp_format" is a special key for LSP formatter modes
          and not vim.tbl_contains({ "trim_newlines", "trim_whitespace" }, formatter)
          and MetaConfig.formatter_name_to_mason_name[formatter] ~= ""
        then
          local mason_name = MetaConfig.formatter_name_to_mason_name[formatter] or formatter
          table.insert(mason_ensure_installed, mason_name)
        end
      end
    end
    vim.g.mason_ensure_installed = vim.list_extend(vim.g.mason_ensure_installed or {}, mason_ensure_installed)
  end,
  opts = {
    formatters_by_ft = formatters_by_ft,
    format_on_save = function(bufnr)
      local enable_message = { lsp_fallback = false, timeout_ms = 500 }

      local autoformat_is_enabled_by_command = vim.b[bufnr].autoformat_mode == "force"
        or (vim.g.autoformat_mode == "force" and (vim.b[bufnr].autoformat_mode or "auto") == "auto")
      if autoformat_is_enabled_by_command then
        return enable_message
      end
      local autoformat_is_disabled_by_command = vim.b[bufnr].autoformat_mode == "disable"
        or (vim.g.autoformat_mode == "disable" and (vim.b[bufnr].autoformat_mode or "auto") == "auto")
      if autoformat_is_disabled_by_command then
        return
      end

      local autoformat_is_disabled_by_config = (
        MetaConfig.disable_autoformat_on_fts == "*"
        or vim.tbl_contains(MetaConfig.disable_autoformat_on_fts or {}, vim.bo.filetype)
      )
      if autoformat_is_disabled_by_config then
        return
      end

      local absolute_file_path = vim.fn.expand("%:p")
      local absolute_cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
      local file_is_in_cwd = string.sub(absolute_file_path, 1, #absolute_cwd_path) == absolute_cwd_path
      if not file_is_in_cwd then
        return
      end

      local relative_file_path = vim.fn.expand("%:p:~")
      local excluded_file_patterns =
        vim.list_extend(MetaConfig.disable_autoformat_on_files or {}, MetaConfig.disable_tooling_on_files or {})
      for _, excluded_file_pattern in ipairs(excluded_file_patterns) do
        local file_is_excluded = relative_file_path:match(excluded_file_pattern)
        if file_is_excluded then
          return
        end
      end

      return enable_message
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- Switch autoformat mode, between "disable", "auto" and "force", globally or per-buffer (the later taking precedence
    -- over the former)
    local function enable_autoformat(args)
      if args.args == "all" and args.bang then
        vim.g.autoformat_mode = "force"
        vim.notify("Autoformat enabled globally (force)", vim.log.levels.INFO, { title = "Autoformat" })
      elseif args.args == "all" then
        vim.g.autoformat_mode = "auto"
        vim.notify("Autoformat enabled globally (auto)", vim.log.levels.INFO, { title = "Autoformat" })
      elseif args.bang then
        vim.b.autoformat_mode = "force"
        vim.notify("Autoformat enabled for current buffer (force)", vim.log.levels.INFO, { title = "Autoformat" })
      else
        vim.b.autoformat_mode = "auto"
        vim.notify("Autoformat enabled for current buffer (auto)", vim.log.levels.INFO, { title = "Autoformat" })
      end
    end
    local function disable_autoformat(args)
      if args.args == "all" then
        vim.g.autoformat_mode = "disable"
        vim.notify("Autoformat disabled globally", vim.log.levels.INFO, { title = "Autoformat" })
      else
        vim.b.autoformat_mode = "disable"
        vim.notify("Autoformat disabled for current buffer", vim.log.levels.INFO, { title = "Autoformat" })
      end
    end
    local function autoformat_is_disabled(args)
      if args.args == "all" then
        return vim.g.autoformat_mode == "disable"
      else
        return vim.b.autoformat_mode == "disable"
      end
    end
    local function toggle_autoformat(args)
      if autoformat_is_disabled(args) then
        enable_autoformat(args)
      else
        disable_autoformat(args)
      end
    end
    vim.api.nvim_create_user_command("AutoformatEnable", enable_autoformat, {
      desc = "Enable autoformat",
      bang = true,
      nargs = "?",
      complete = function() return { "all" } end,
    })
    vim.api.nvim_create_user_command("AutoformatDisable", disable_autoformat, {
      desc = "Disable autoformat",
      nargs = "?",
      complete = function() return { "all" } end,
    })
    vim.api.nvim_create_user_command("AutoformatToggle", toggle_autoformat, {
      desc = "Toggle autoformat",
      bang = true,
      nargs = "?",
      complete = function() return { "all" } end,
    })
  end,
}
