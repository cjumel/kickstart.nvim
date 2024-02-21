local M = {}

M.gruvbox_enabled = true
M.gruvbox_background = "dark"

M.lualine_opts = {
  options = {
    theme = "gruvbox-material",
    refresh = {
      statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
  },
}

return M
