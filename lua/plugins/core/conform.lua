return {
  "stevearc/conform.nvim",
  dependencies = { "mason-org/mason.nvim" },
  ft = vim.tbl_keys(require("config.data").formatters_by_ft), -- `vim.g.formatters_by_ft` is not known at this stage so it can't be used
  opts = function()
    ---@type nvim_config.FormattersByFiletype
    local formatters_by_ft =
      vim.tbl_deep_extend("force", require("config.data").formatters_by_ft, vim.g.formatters_by_ft or {})
    return {
      formatters_by_ft = formatters_by_ft,
      format_on_save = function(bufnr)
        if vim.b[bufnr].format_on_save_is_disabled or vim.g.format_on_save_is_disabled then
          return
        end
        return { lsp_fallback = false, timeout_ms = 500 }
      end,
    }
  end,
}
