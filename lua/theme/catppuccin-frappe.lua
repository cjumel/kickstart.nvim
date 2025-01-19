local custom_lualine = require("custom.lualine")

local M = {}

M.catppuccin_enabled = true
M.catppuccin_opts = {
  flavour = "frappe", -- latte, frappe, macchiato, mocha
}

local custom_sections = vim.tbl_deep_extend("force", custom_lualine.preset_sections.default, {
  lualine_a = { { "mode", separator = { left = "", right = "" } } },
})
M.lualine_opts = {
  options = { section_separators = { left = "", right = "" } },
  sections = custom_sections,
  extensions = custom_lualine.build_extensions(custom_sections),
}

return M
