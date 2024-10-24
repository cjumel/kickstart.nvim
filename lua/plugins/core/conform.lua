-- conform.nvim
--
-- conform.nvim is a lightweight yet powerful formatter plugin for Neovim. It is my plugin of choice for formatting and
-- auto-formatting due to its great flexibility and customizability, while still remaining quite simple compared to
-- alternatives like null-ls.

local nvim_config = require("nvim_config")
local path_utils = require("path_utils")

return {
  "stevearc/conform.nvim",
  cond = not nvim_config.light_mode,
  dependencies = { "williamboman/mason.nvim" },
  ft = vim.tbl_keys(nvim_config.formatters_by_ft),
  init = function()
    -- Enable conform formatting with Neovim's builtin formatting (see `:h gq`)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    local mason_ensure_installed = {}
    local formatter_to_mason_name = { -- Specify the name of the Mason package for formatters where they differ
      ruff_fix = "ruff",
      ruff_format = "ruff",
    }
    for _, formatters in pairs(nvim_config.formatters_by_ft) do
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
    formatters_by_ft = nvim_config.formatters_by_ft,
    format_on_save = function(bufnr)
      local format_on_save_is_disabled_by_nvim_config = (
        nvim_config.disable_format_on_save_on_fts == "*"
        or (
          nvim_config.disable_format_on_save_on_fts
          and vim.tbl_contains(nvim_config.disable_format_on_save_on_fts, vim.bo.filetype)
        )
      )
      local format_on_save_is_disabled_by_command = vim.g.disable_format_on_save or vim.b[bufnr].disable_format_on_save

      if
        format_on_save_is_disabled_by_nvim_config
        or format_on_save_is_disabled_by_command
        or (not path_utils.file_is_in_project())
        or path_utils.file_matches_tooling_blacklist_patterns()
      then
        return
      end

      return { lsp_fallback = false, timeout_ms = 500 }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- Create command to toggle format-on-save
    -- Used with a bang ("!"), the disable command will disable format-on-save just for the current buffer
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
  end,
}
