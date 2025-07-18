local M = {}

local custom_modules = require("config.lualine.custom_modules")

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
  lualine_x = {
    custom_modules.macro,
    custom_modules.searchcount,
    "filetype",
  },
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
  lualine_x = {
    custom_modules.macro,
    custom_modules.searchcount,
    "filetype",
    "location",
    "progress",
  },
  lualine_y = {},
  lualine_z = {},
}

return M
