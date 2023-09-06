-- lualine.nvim
--
-- A blazing fast and customizable status bar with Lua.

return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = false,
      theme = 'catppuccin',
      component_separators = '|',
      section_separators = '',
    },
  },
}
