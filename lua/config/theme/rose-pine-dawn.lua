local M = {}

M.background = "light"

M.rose_pine_enabled = true
M.rose_pine_style = "dawn"

M.get_lualine_opts = function()
  local default_theme = require("config.theme.default")
  return { sections = default_theme.get_lualine_opts().sections }
end
M.lualine_callback = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
