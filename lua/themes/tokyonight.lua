local M = {}

M.tokyonight_enabled = true
M.tokyonight_opts = {
  style = "night", -- night, moon, storm or day
  transparent = true,
}

M.lualine_opts = {
  options = {
    theme = "tokyonight",
    component_separators = "",
    section_separators = { left = "", right = "" },
  },
}

return M
