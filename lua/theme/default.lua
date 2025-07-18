local M = {}

local lualine_config = require("config.lualine")

M.options_callback = function()
  -- Remove Neovim background colors to enable transparency
  vim.cmd.highlight("Normal guibg=none")
  vim.cmd.highlight("NonText guibg=none")
  vim.cmd.highlight("Normal ctermbg=none")
  vim.cmd.highlight("NonText ctermbg=none")
end

M.lualine_opts = {
  options = {
    icons_enabled = false,
    theme = { -- Remove Lualine colors (colors associated with the default theme are not super readable)
      inactive = { c = {} },
      visual = { c = {} },
      replace = { c = {} },
      normal = { c = {} },
      insert = { c = {} },
      command = { c = {} },
    },
  },
  sections = lualine_config.preset_sections.minimalist,
}
M.lualine_callback = function()
  vim.opt.showmode = true -- Show mode in status line
end

return M
