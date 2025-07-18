local M = {}

local lualine_config = require("config.lualine")

M.background = "light"

M.rose_pine_enabled = true
M.rose_pine_style = "dawn"

M.lualine_opts = {
  sections = lualine_config.preset_sections.minimalist,
}
M.lualine_callback = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
