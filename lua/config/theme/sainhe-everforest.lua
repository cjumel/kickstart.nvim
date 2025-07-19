local M = {}

M.everforest_enabled = true

M.get_lualine_opts = function()
  return {
    options = {
      theme = "everforest",
      section_separators = { left = "", right = "" },
    },
  }
end

return M
