local M = {}

M.background = "light"

M.gruvbox_enabled = true
M.gruvbox_style = "light"

M.get_lualine_opts = function(_)
  return {
    options = {
      theme = "gruvbox_light",
    },
  }
end

return M
