local M = {}

M.tokyonight_enabled = true
M.tokyonight_opts = {
  style = "storm", -- night, moon, storm or day
}

M.lualine_opts = {
  options = {
    icons_enabled = false,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
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
