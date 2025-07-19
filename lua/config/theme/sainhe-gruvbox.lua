local M = {}

M.gruvbox_material_enabled = true

M.get_lualine_opts = function()
  return {
    options = {
      theme = "gruvbox-material",
      section_separators = { left = "", right = "" },
    },
  }
end

return M
