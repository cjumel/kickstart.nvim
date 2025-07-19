local M = {}

M.gruvbox_enabled = true
M.gruvbox_style = "dark"

M.get_lualine_opts = function()
  return {
    options = {
      theme = "gruvbox_dark",
    },
  }
end

return M
