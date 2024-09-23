local extensions = require("plugins.ui.lualine.extensions")
local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

-- Make background transparent
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])

local M = {}

local custom_sections = vim.tbl_deep_extend("force", sections.empty, {
  lualine_c = {
    { "filename", path = 1 }, -- Relative file path
    "diff",
    "diagnostics",
  },
  lualine_x = { modules.macro, "filetype", "location", "progress" },
})
M.lualine_opts = {
  options = {
    theme = "16color",
  },
  sections = custom_sections,
  extensions = extensions.build_extensions(custom_sections),
  _keep_showmode = true,
}

return M
