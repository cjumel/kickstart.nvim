local M = {}

M.kanagawa_enabled = true

M.lualine_opts = {
  options = {
    component_separators = "",
    section_separators = "",
    refresh = {
      statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
  },
}

return M
