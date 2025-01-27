local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.catppuccin_enabled = true
M.catppuccin_style = "macchiato"

local custom_sections = vim.tbl_deep_extend("force", sections.default, {
  lualine_a = { { "mode", separator = { left = "" } } },
  lualine_z = { { "progress", separator = { right = "" } } },
})

M.lualine_opts = {
  options = { section_separators = { left = "", right = "" } },
  sections = custom_sections,
  extensions = extensions.build_extensions(custom_sections),
}

return M
