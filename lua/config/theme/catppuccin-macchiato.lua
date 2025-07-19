local M = {}

M.catppuccin_enabled = true
M.catppuccin_style = "macchiato"

M.get_lualine_opts = function(opts)
  return {
    options = { section_separators = { left = "", right = "" } },
    sections = vim.tbl_deep_extend("force", opts.sections, {
      lualine_a = { { "mode", separator = { left = "" } } },
      lualine_z = { { "progress", separator = { right = "" } } },
    }),
  }
end

return M
