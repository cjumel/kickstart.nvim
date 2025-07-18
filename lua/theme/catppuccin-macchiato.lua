local M = {}

local lualine_config = require("config.lualine")

M.catppuccin_enabled = true
M.catppuccin_style = "macchiato"

M.lualine_opts = {
  options = { section_separators = { left = "", right = "" } },
  sections = vim.tbl_deep_extend("force", lualine_config.preset_sections.default, {
    lualine_a = { { "mode", separator = { left = "" } } },
    lualine_z = { { "progress", separator = { right = "" } } },
  }),
}

return M
