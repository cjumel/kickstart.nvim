local extensions = require("plugins.ui.lualine.extensions")
local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.catppuccin_enabled = true
M.catppuccin_opts = {
  flavour = "latte", -- latte, frappe, macchiato, mocha
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

M.headlines_opts = {
  markdown = {
    headline_highlights = {
      "Headline1",
      "Headline2",
      "Headline3",
      "Headline4",
      "Headline5",
      "Headline6",
    },
  },
}

return M
