-- conform.nvim
--
-- conform.nvim is a lightweight yet powerful formatter plugin for Neovim. It is my plugin of choice for formatting and
-- auto-formatting due to its great flexibility and customizability, while still remaining quite simple compared to
-- alternatives like null-ls.

return {
  "stevearc/conform.nvim",
  cond = not require("config")["light_mode"],
  dependencies = { "williamboman/mason.nvim" },
  ft = vim.tbl_keys(require("config").formatters_by_ft),
  init = function()
    -- Enable conform formatting with Neovim's builtin formatting (see `:h gq`)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    local mason_ensure_installed = {}
    local formatter_to_mason_name = { -- Specify the name of the Mason package for formatters where they differ
      ruff_fix = "ruff",
      ruff_format = "ruff",
    }
    for _, formatters in pairs(require("config").formatters_by_ft) do
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
    formatters_by_ft = require("config").formatters_by_ft,
    format_on_save = function(bufnr)
      if
        ( -- Check Neovim configuration option to disable format-on-save on filetypes
          require("config")["disable_format_on_save_on_fts"] == "*"
          or (
            require("config")["disable_format_on_save_on_fts"]
            and vim.tbl_contains(require("config")["disable_format_on_save_on_fts"], vim.bo.filetype)
          )
        )
        -- Check command to toggle format on save
        or (vim.g.disable_format_on_save or vim.b[bufnr].disable_format_on_save)
        -- Check buffer is in current project (cwd or Git repository containing the cwd)
        or not require("buffer").is_in_project()
        -- Check buffer is not in an external dependency (e.g. installed by package managers)
        or require("buffer").is_external_dependency()
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
