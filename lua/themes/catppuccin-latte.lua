local M = {}

M.catppuccin_enabled = true
M.catppuccin_opts = {
  flavour = "latte", -- latte, frappe, macchiato, mocha
}

M.lualine_opts = {
  options = {
    component_separators = "",
    section_separators = { left = "", right = "" },
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
