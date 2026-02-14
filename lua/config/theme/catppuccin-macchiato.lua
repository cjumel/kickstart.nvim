---@type ThemeConfig
return {
  background = "dark",
  colorscheme_name = "catppuccin",
  colorscheme_opts = { flavour = "macchiato" },
  lualine_opts = {
    options = { section_separators = { left = "", right = "" } },
    sections = {
      lualine_a = { { "mode", separator = { left = "" } } },
      lualine_z = { { "progress", separator = { right = "" } } },
    },
  },
}
