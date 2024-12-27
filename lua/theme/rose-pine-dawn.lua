local extensions = require("plugins.ui.lualine.extensions")
local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.rose_pine_enabled = true
M.rose_pine_opts = {
  variant = "dawn", -- auto, main, moon, or dawn
}

local custom_sections = vim.tbl_deep_extend("force", sections.empty, {
  lualine_c = {
    { "filename", path = 1 }, -- Relative file path
    "diff",
    "diagnostics",
    "aerial",
  },
  lualine_x = { modules.macro, "filetype", "location", "progress" },
})
M.lualine_opts = {
  sections = custom_sections,
  extensions = extensions.build_extensions(custom_sections),
  _keep_showmode = true,
}

return M
