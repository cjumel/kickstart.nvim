local M = {}

M.onedark_enabled = true
M.onedark_style = "dark"

M.get_lualine_opts = function(_)
  return {
    options = {
      theme = "onedark",
    },
  }
end

return M
