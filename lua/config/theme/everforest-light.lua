local M = {}

M.background = "light"
M.everforest_enabled = true

M.get_lualine_opts = function(_)
  return {
    options = {
      theme = "everforest",
      section_separators = { left = "", right = "" },
    },
  }
end

return M
