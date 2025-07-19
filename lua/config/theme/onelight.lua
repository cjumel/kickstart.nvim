local M = {}

M.background = "light"

M.onedark_enabled = true
M.onedark_style = "light"

M.get_lualine_opts = function()
  return {
    options = {
      theme = "onelight",
    },
  }
end

return M
