local M = {}

M.catppuccin_enabled = true
M.catppuccin_style = "frappe"

M.get_lualine_opts = function(opts)
  return {
    options = { section_separators = { left = "", right = "" } },
    sections = vim.tbl_deep_extend("force", opts.sections, {
      lualine_a = { { "mode", separator = { left = "", right = "" } } },
    }),
  }
end

return M
