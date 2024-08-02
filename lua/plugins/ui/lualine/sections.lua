local modules = require("plugins.ui.lualine.modules")

local M = {}

M.default = {
  lualine_a = { "mode" },
  lualine_b = { "branch", "diff", "diagnostics" },
  lualine_c = {
    {
      "filename",
      path = 1, -- Relative path
      symbols = { modified = "●" }, -- Text to show when the buffer is modified
    },
  },
  lualine_x = { modules.macro, "filetype" },
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
