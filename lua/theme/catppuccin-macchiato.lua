local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.catppuccin_enabled = true
M.catppuccin_opts = {
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
}

M.lualine_opts = {
  sections = sections.minimalist,
  extensions = extensions.build_extensions(sections.minimalist),
}
M.lualine_post_setup = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
