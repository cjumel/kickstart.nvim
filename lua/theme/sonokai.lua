local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.sonokai_enabled = true

M.lualine_opts = {
  options = {
    theme = "sonokai",
  },
  sections = sections.minimalist,
  extensions = extensions.build_extensions(sections.minimalist),
}
M.lualine_post_setup = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
