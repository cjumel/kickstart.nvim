local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.options_callback = function()
  -- Remove Neovim background colors
  vim.cmd.highlight("Normal guibg=none")
  vim.cmd.highlight("NonText guibg=none")
  vim.cmd.highlight("Normal ctermbg=none")
  vim.cmd.highlight("NonText ctermbg=none")
end

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
  sections = sections.minimalist,
  extensions = extensions.build_extensions(sections.minimalist),
}
M.lualine_callback = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
