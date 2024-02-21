local M = {}

M.nord_enabled = true

M.lualine_opts = {
  options = {
    icons_enabled = false,
    theme = "nord",
    refresh = {
      statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
  },
}

return M
