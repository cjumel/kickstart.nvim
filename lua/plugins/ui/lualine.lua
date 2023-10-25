-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    options = {
      theme = "catppuccin",
      component_separators = "|",
      section_separators = "",
    },
  },
}
