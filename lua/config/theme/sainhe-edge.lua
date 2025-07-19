local M = {}

M.edge_enabled = true

M.get_lualine_opts = function()
  return {
    options = {
      theme = "edge",
      section_separators = { left = "", right = "" },
    },
  }
end

return M
