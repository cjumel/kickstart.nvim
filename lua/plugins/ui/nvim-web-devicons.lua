-- Default icon data can be found in:
-- https://github.com/nvim-tree/nvim-web-devicons/tree/master/lua/nvim-web-devicons/default
-- https://github.com/nvim-tree/nvim-web-devicons/tree/master/lua/nvim-web-devicons/light
local extra_filaname_to_icon = {
  dark = {
    [".aliases"] = { icon = "", color = "#89E051", cterm_color = "113", name = "Zsh" },
    [".bash_aliases"] = { icon = "", color = "#4D5A5E", cterm_color = "240", name = "Sh" },
    [".coverage"] = { icon = "", color = "#DAD8D8", cterm_color = "188", name = "Sql" },
    [".DS_Store"] = { icon = "", color = "#FFF2F2", cterm_color = "255", name = "AppleCustom" },
    [".env.example"] = { icon = "", color = "#FAF743", cterm_color = "227", name = "Env" },
    [".env.sample"] = { icon = "", color = "#FAF743", cterm_color = "227", name = "Env" },
    [".env.test"] = { icon = "", color = "#FAF743", cterm_color = "227", name = "Env" },
    [".markdownlintrc"] = { icon = "", color = "#CBCB41", cterm_color = "185", name = "Json" },
    [".python-version"] = { icon = "", color = "#9C4221", cterm_color = "124", name = "PythonVersionCustom" },
    [".shellcheckrc"] = { icon = "", color = "#6D8086", cterm_color = "66", name = "Conf" },
    [".stow-local-ignore"] = { icon = "", color = "#6D8086", cterm_color = "66", name = "Conf" },
    ["ignore"] = { icon = "", color = "#F54D27", cterm_color = "196", name = "GitIgnore" },
    ["sketchybarrc"] = { icon = "", color = "#4D5A5E", cterm_color = "240", name = "Sh" },
    ["ripgreprc"] = { icon = "", color = "#6D8086", cterm_color = "66", name = "Conf" },
  },
  light = {
    [".aliases"] = { icon = "", color = "#447028", cterm_color = "22", name = "Zsh" },
    [".bash_aliases"] = { icon = "", color = "#3A4446", cterm_color = "238", name = "Sh" },
    [".coverage"] = { icon = "", color = "#494848", cterm_color = "238", name = "Sql" },
    [".DS_Store"] = { icon = "", color = "#333030", cterm_color = "236", name = "AppleCustom" },
    [".env.example"] = { icon = "", color = "#32310D", cterm_color = "236", name = "Env" },
    [".env.sample"] = { icon = "", color = "#32310D", cterm_color = "236", name = "Env" },
    [".env.test"] = { icon = "", color = "#32310D", cterm_color = "236", name = "Env" },
    [".markdownlintrc"] = { icon = "", color = "#666620", cterm_color = "58", name = "Json" },
    [".python-version"] = { icon = "", color = "#753219", cterm_color = "88", name = "PythonVersionCustom" },
    [".shellcheckrc"] = { icon = "", color = "#526064", cterm_color = "59", name = "Conf" },
    [".stow-local-ignore"] = { icon = "", color = "#526064", cterm_color = "59", name = "Conf" },
    ["ignore"] = { icon = "", color = "#B83A1D", cterm_color = "160", name = "GitIgnore" },
    ["sketchybarrc"] = { icon = "", color = "#3A4446", cterm_color = "238", name = "Sh" },
    ["ripgreprc"] = { icon = "", color = "#526064", cterm_color = "59", name = "Conf" },
  },
}

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Only used by many plugins as a dpendency
  opts = function()
    return {
      override_by_filename = extra_filaname_to_icon[ThemeConfig.background or "dark"], -- Icon customization by filename
    }
  end,
}
