local M = {}

M.tokyonight_enabled = true
M.tokyonight_opts = {
  style = "night", -- night, moon, storm or day
}

M.lualine_opts = {
  options = {
    component_separators = {},
  },
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
