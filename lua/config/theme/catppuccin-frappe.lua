local M = {}

local preset_sections = require("plugins.ui.lualine.preset_sections")

M.catppuccin_enabled = true
M.catppuccin_style = "frappe"

M.lualine_opts = {
  options = { section_separators = { left = "", right = "" } },
  sections = vim.tbl_deep_extend("force", preset_sections.default, {
    lualine_a = { { "mode", separator = { left = "", right = "" } } },
  }),
}

return M
