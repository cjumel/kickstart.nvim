local M = {}

M.onedark_enabled = true

M.lualine_opts = {
  options = {
    icons_enabled = false,
    theme = "onedark",
    refresh = {
      statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
  },
}

return M
