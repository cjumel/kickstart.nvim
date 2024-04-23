local extensions = require("plugins.ui.lualine.extensions")
local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.tokyonight_enabled = true
M.tokyonight_opts = {
  style = "night", -- night, moon, storm or day
}

local custom_sections = vim.tbl_deep_extend("force", sections.empty, {
  lualine_c = {
    { "filename", path = 1 }, -- Relative file path
    "diff",
    "diagnostics",
  },
  lualine_x = { modules.macro, modules.harpoon, "location", "progress" },
})
M.lualine_opts = {
  sections = custom_sections,
  extensions = extensions.build_extensions(custom_sections),
}

return M
