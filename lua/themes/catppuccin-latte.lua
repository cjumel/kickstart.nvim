local M = {}

M.catppuccin_enabled = true
M.catppuccin_opts = {
  flavour = "latte", -- latte, frappe, macchiato, mocha
}

M.lualine_opts = {
  options = {
    component_separators = "",
    section_separators = { left = "", right = "" },
  },
}

return M
