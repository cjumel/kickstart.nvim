local M = {}

M.tokyonight_enabled = true

M.lualine_opts = {
  options = {
    theme = "tokyonight",
    component_separators = "",
    section_separators = { left = "", right = "" },
    refresh = {
      statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
  },
}

return M
