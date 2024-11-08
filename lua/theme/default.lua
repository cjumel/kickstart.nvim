local extensions = require("plugins.ui.lualine.extensions")
local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

local M = {}

local custom_sections = vim.tbl_deep_extend("force", sections.empty, {
  lualine_c = {
    { "filename", path = 1 }, -- Relative file path
    "diff",
    "diagnostics",
    "aerial",
  },
  lualine_x = { modules.macro, modules.harpoon, "filetype", "location", "progress" },
})
M.lualine_opts = {
  options = {
    theme = { -- Remove Lualine colors
      inactive = { c = {} },
      visual = { c = {} },
      replace = { c = {} },
      normal = { c = {} },
      insert = { c = {} },
      command = { c = {} },
    },
  },
  sections = custom_sections,
  extensions = extensions.build_extensions(custom_sections),
  _keep_showmode = true,
}

-- Remove Neovim background colors
vim.cmd.highlight("Normal guibg=none")
vim.cmd.highlight("NonText guibg=none")
vim.cmd.highlight("Normal ctermbg=none")
vim.cmd.highlight("NonText ctermbg=none")

return M
