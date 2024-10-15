local lualine_modules = require("plugins.ui.lualine.modules")

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
  lualine_x = { lualine_modules.macro, lualine_modules.harpoon, "filetype" },
  lualine_y = { "location" },
  lualine_z = { "progress" },
}

M.empty = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

return M
