local custom_lualine = require("lualine.custom")

local M = {}

M.rose_pine_enabled = true
M.rose_pine_opts = {
  variant = "main", -- auto, main, moon, or dawn
}

M.lualine_opts = {
  sections = custom_lualine.sections.minimalist,
  extensions = custom_lualine.build_extensions(custom_lualine.sections.minimalist),
}
M.lualine_callback = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
