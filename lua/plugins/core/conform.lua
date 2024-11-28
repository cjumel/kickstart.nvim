-- conform.nvim
--
-- conform.nvim is a lightweight yet powerful formatter plugin for Neovim. It is my plugin of choice for formatting and
-- auto-formatting due to its great flexibility and customizability, while still remaining quite simple compared to
-- alternatives like null-ls.

local nvim_config = require("nvim_config")

-- Specify the name of the Mason package corresponding to formatters when they differ
local formatter_to_mason_name = {
  ruff_fix = "ruff",
  ruff_format = "ruff",
}

local formatters_by_ft = {}
for ft, formatters in pairs(nvim_config.formatters_by_ft) do
  local formatter_is_disabled = (
    nvim_config.disable_format_on_fts == "*" or vim.tbl_contains(nvim_config.disable_format_on_fts or {}, ft)
  )
  if not formatter_is_disabled then
    formatters_by_ft[ft] = formatters
  end
end

return {
  "stevearc/conform.nvim",
  cond = not nvim_config.light_mode,
  dependencies = { "williamboman/mason.nvim" },
  ft = vim.tbl_keys(formatters_by_ft),
  init = function()
    -- Enable conform formatting with Neovim's builtin formatting (see `:h gq`)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    local mason_ensure_installed = {}
    for _, formatters in pairs(formatters_by_ft) do
      for formatter_key, formatter in ipairs(formatters) do
        if
          formatter_key ~= "lsp_format" -- "lsp_format" is a special key for LSP formatter modes
          and not vim.tbl_contains(
            { "trim_newlines", "trim_whitespace" }, -- Formatters which have no Mason package associated with
            formatter
          )
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

      for _, path_pattern in ipairs(nvim_config.tooling_blacklist_path_patterns or {}) do
        local file_matches_tooling_blacklist_pattern = absolute_file_path:match(path_pattern)
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
      else
        vim.g.disable_format_on_save = true
      end
    end, { desc = "Disable format-on-save", bang = true })
    vim.api.nvim_create_user_command("FormatOnSaveEnable", function()
      vim.b.disable_format_on_save = false
      vim.g.disable_format_on_save = false
    end, { desc = "Enable format-on-save" })
    vim.api.nvim_create_user_command("FormatOnSaveToggle", function(args)
      if vim.b.disable_format_on_save or vim.g.disable_format_on_save then -- Format-on-save is disabled
        vim.b.disable_format_on_save = false
        vim.g.disable_format_on_save = false
      else
        if args.bang then
          vim.b.disable_format_on_save = true
        else
          vim.g.disable_format_on_save = true
        end
      end
    end, { desc = "Toggle format-on-save", bang = true })
  end,
}
