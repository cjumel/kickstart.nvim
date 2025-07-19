local M = {}

local preset_sections = require("plugins.ui.lualine.preset_sections")

M.rose_pine_enabled = true
M.rose_pine_style = "moon"

M.lualine_opts = {
  sections = preset_sections.minimalist,
}
M.lualine_callback = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
