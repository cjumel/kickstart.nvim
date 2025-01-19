local modules = require("plugins.ui.lualine.modules")

local M = {}

M.default = {
  lualine_a = { "mode" },
  lualine_b = { "branch" },
  lualine_c = {
    {
      "filename",
      path = 1, -- Relative path
      symbols = { modified = "●" }, -- Text to show when the buffer is modified
    },
    "diff",
    "diagnostics",
  },
  lualine_x = { modules.macro, "filetype" },
  lualine_y = { "location" },
  lualine_z = { "progress" },
}

M.minimalist = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {
    { "filename", path = 1 }, -- Relative file path
    "diff",
    "diagnostics",
  },
  lualine_x = { modules.macro, "filetype", "location", "progress" },
  lualine_y = {},
  lualine_z = {},
}

return M
