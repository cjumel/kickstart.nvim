local M = {}

M.sonokai_enabled = true

M.get_lualine_opts = function(_)
  return {
    options = {
      theme = "sonokai",
      section_separators = { left = "", right = "" },
    },
  }
end

return M
