local M = {}

M.nord_enabled = true

M.get_lualine_opts = function(_)
  return {
    options = {
      theme = "nord",
      section_separators = { left = "", right = "" },
    },
  }
end

return M
