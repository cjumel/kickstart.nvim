-- conform.nvim
--
-- conform.nvim is a lightweight yet powerful formatter plugin for Neovim. It is my plugin of choice for formatting and
-- auto-formatting due to its great flexibility and customizability, while still remaining quite simple compared to
-- alternatives like null-ls.

local formatter_to_mason_name = { -- Names of the Mason package corresponding to formatters when they differ
  ruff_fix = "ruff",
  ruff_format = "ruff",
  ruff_organize_imports = "ruff",
}
local formatters_without_mason = { -- Names of the formatters which have no Mason package associated with
  "rustfmt", -- Should be installed with rustup
  "trim_newlines",
  "trim_whitespace",
}

local formatters_by_ft = {}
for ft, formatters in pairs(Metaconfig.formatters_by_ft or {}) do
  if formatters then
    formatters_by_ft[ft] = formatters
  end
end

return {
  "stevearc/conform.nvim",
  cond = not Metaconfig.light_mode,
  dependencies = { "williamboman/mason.nvim" },
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
          and not vim.tbl_contains(formatters_without_mason, formatter)
        then
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
      local format_on_save_is_disabled_by_config = (
        Metaconfig.disable_format_on_save_on_fts == "*"
        or vim.tbl_contains(Metaconfig.disable_format_on_save_on_fts or {}, vim.bo.filetype)
      )
      if format_on_save_is_disabled_by_config then
        return
      end

      local format_on_save_is_disabled_by_command = vim.g.disable_format_on_save or vim.b[bufnr].disable_format_on_save
      if format_on_save_is_disabled_by_command then
        return
      end

      local absolute_file_path = vim.fn.expand("%:p")
      local absolute_cwd_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
      local file_is_in_cwd = string.sub(absolute_file_path, 1, #absolute_cwd_path) == absolute_cwd_path
      if not file_is_in_cwd then
        return
      end

      local relative_file_path = vim.fn.expand("%:p:~")
      for _, path_pattern in ipairs(Metaconfig.tooling_blacklist_path_patterns or {}) do
        local file_matches_tooling_blacklist_pattern = relative_file_path:match(path_pattern)
        if file_matches_tooling_blacklist_pattern then
          return
        end
      end

      return { lsp_fallback = false, timeout_ms = 500 }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- Create command to toggle format-on-save
    -- Used with a bang ("!"), the disable command will disable format-on-save just for the current buffer (there's no
    -- case where the bang can be useful for the enable command)
    vim.api.nvim_create_user_command("FormatOnSaveDisable", function(args)
      if args.bang then
        vim.b.disable_format_on_save = true
        vim.notify("Format-on-save disabled for current buffer")
      else
        vim.g.disable_format_on_save = true
        vim.notify("Format-on-save disabled globally")
      end
    end, { desc = "Disable format-on-save", bang = true })
    vim.api.nvim_create_user_command("FormatOnSaveEnable", function()
      vim.b.disable_format_on_save = false
      vim.g.disable_format_on_save = false
      vim.notify("Format-on-save enabled")
    end, { desc = "Enable format-on-save" })
    vim.api.nvim_create_user_command("FormatOnSaveToggle", function(args)
      if vim.b.disable_format_on_save or vim.g.disable_format_on_save then -- Format-on-save is disabled
        vim.b.disable_format_on_save = false
        vim.g.disable_format_on_save = false
        vim.notify("Format-on-save enabled")
      else
        if args.bang then
          vim.b.disable_format_on_save = true
          vim.notify("Format-on-save disabled for current buffer")
        else
          vim.g.disable_format_on_save = true
          vim.notify("Format-on-save disabled globally")
        end
      end
    end, { desc = "Toggle format-on-save", bang = true })
  end,
}
