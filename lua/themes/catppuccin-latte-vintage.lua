local M = {}

M.catppuccin_enabled = true
M.catppuccin_opts = {
  flavour = "latte", -- latte, frappe, macchiato, mocha
  transparent_background = false,
}

M.noice_enabled = false

M.lualine_opts = {
  options = {
    icons_enabled = false,
    theme = "auto",
    component_separators = "|",
    section_separators = "",
  },
}

return M
