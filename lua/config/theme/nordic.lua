local M = {}

M.nordic_enabled = true

M.get_lualine_opts = function()
  return {
    options = {
      theme = "nordic",
      section_separators = { left = "", right = "" },
    },
  }
end

return M
