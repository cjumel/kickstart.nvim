local formatters_by_ft = {}
for ft, formatters in pairs(MetaConfig.formatters_by_ft or {}) do
  if formatters then
    formatters_by_ft[ft] = formatters
  end
end

return {
  "stevearc/conform.nvim",
  dependencies = { "mason-org/mason.nvim" },
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

    -- Create user commands to switch format on save mode, between "disable", "auto" and "force" (when command is used
    -- with a bang), globally or per-buffer (the later taking precedence over the former)
    local function notify(msg) vim.notify(msg, vim.log.levels.INFO, { title = "Format on save" }) end
    local function disable_format_on_save(args)
      if args.args == "all" then
        vim.g.format_on_save_mode = "disable"
        notify("Format on save disabled globally")
      else
        vim.b.format_on_save_mode = "disable"
        notify("Format on save disabled for current buffer")
      end
    end
    local function enable_format_on_save(args)
      if args.args == "all" and args.bang then
        vim.g.format_on_save_mode = "force"
        notify("Format on save enabled globally (force)")
      elseif args.args == "all" then
        vim.g.format_on_save_mode = "auto"
        notify("Format on save enabled globally (auto)")
      elseif args.bang then
        vim.b.format_on_save_mode = "force"
        notify("Format on save enabled for current buffer (force)")
      else
        vim.b.format_on_save_mode = "auto"
        notify("Format on save enabled for current buffer (auto)")
      end
    end
    local function format_on_save_is_disabled(args)
      if args.args == "all" then
        return vim.g.format_on_save_mode == "disable"
      else
        return vim.b.format_on_save_mode == "disable"
      end
    end
    local function toggle_format_on_save(args)
      if format_on_save_is_disabled(args) then
        enable_format_on_save(args)
      else
        disable_format_on_save(args)
      end
    end
    local function format_on_save_status()
      local message = "Format on save global mode: "
        .. (vim.g.format_on_save_mode or "auto")
        .. "\n"
        .. "Format on save buffer mode: "
        .. (vim.b.format_on_save_mode or "auto")
      notify(message)
    end
    vim.api.nvim_create_user_command("FormatOnSaveDisable", disable_format_on_save, {
      desc = "Disable format on save",
      nargs = "?", -- 0 or 1 argument
      complete = function() return { "all" } end, -- Command line autocompletion
    })
    vim.api.nvim_create_user_command("FormatOnSaveEnable", enable_format_on_save, {
      desc = "Enable format on save",
      bang = true,
      nargs = "?", -- 0 or 1 argument
      complete = function() return { "all" } end, -- Command line autocompletion
    })
    vim.api.nvim_create_user_command("FormatOnSaveToggle", toggle_format_on_save, {
      desc = "Toggle format on save",
      bang = true,
      nargs = "?", -- 0 or 1 argument
      complete = function() return { "all" } end, -- Command line autocompletion
    })
    vim.api.nvim_create_user_command("FormatOnSaveStatus", format_on_save_status, {
      desc = "Show format on save status",
    })
  end,
  opts = {
    formatters_by_ft = formatters_by_ft,
    format_on_save = function(bufnr)
      local enable_message = { lsp_fallback = false, timeout_ms = 500 }

      local format_on_save_is_enabled_by_command = vim.b[bufnr].format_on_save_mode == "force"
        or (vim.g.format_on_save_mode == "force" and (vim.b[bufnr].format_on_save_mode or "auto") == "auto")
      if format_on_save_is_enabled_by_command then
        return enable_message
      end
      local format_on_save_is_disabled_by_command = vim.b[bufnr].format_on_save_mode == "disable"
        or (vim.g.format_on_save_mode == "disable" and (vim.b[bufnr].format_on_save_mode or "auto") == "auto")
      if format_on_save_is_disabled_by_command then
        return
      end

      local format_on_save_is_disabled_by_config = (
        MetaConfig.disable_format_on_save_on_fts == "*"
        or vim.tbl_contains(MetaConfig.disable_format_on_save_on_fts or {}, vim.bo.filetype)
      )
      if format_on_save_is_disabled_by_config then
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
        vim.list_extend(MetaConfig.disable_format_on_save_on_files or {}, MetaConfig.disable_tooling_on_files or {})
      for _, excluded_file_pattern in ipairs(excluded_file_patterns) do
        local file_is_excluded = relative_file_path:match(excluded_file_pattern)
        if file_is_excluded then
          return
        end
      end

      return enable_message
    end,
  },
}
