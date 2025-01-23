local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.gruvbox_enabled = true
M.gruvbox_background = "light"

M.lualine_opts = {
  options = {
    theme = "gruvbox_light",
  },
  sections = sections.minimalist,
  extensions = extensions.build_extensions(sections.minimalist),
}
M.lualine_callback = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
