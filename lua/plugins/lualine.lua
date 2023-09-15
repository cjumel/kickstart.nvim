-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

return {
  "nvim-lualine/lualine.nvim",
  priority = 1000, -- UI stuff should be loaded first
  opts = {
    options = {
      icons_enabled = false,
      theme = "catppuccin",
      component_separators = "|",
      section_separators = "",
    },
  },
}
