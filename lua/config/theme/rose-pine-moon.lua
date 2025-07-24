local M = {}

M.rose_pine_enabled = true
M.rose_pine_style = "moon"

M.options_callback = function()
  vim.opt.showmode = true -- Show mode in status line
end

M.get_lualine_opts = function(_)
  local default_theme = require("config.theme.default")
  return { sections = default_theme.get_lualine_opts().sections }
end

return M
