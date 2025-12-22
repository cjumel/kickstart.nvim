-- Default icon data can be found in:
-- https://github.com/nvim-tree/nvim-web-devicons/tree/master/lua/nvim-web-devicons/default
-- https://github.com/nvim-tree/nvim-web-devicons/tree/master/lua/nvim-web-devicons/light
local extra_filaname_to_icon = {
  dark = {
    [".aliases"] = { icon = "󱆃", color = "#6D8086", cterm_color = "66", name = "Aliases" },
    [".bash_aliases"] = { icon = "󱆃", color = "#6D8086", cterm_color = "66", name = "BashAliases" },
    [".coverage"] = { icon = "", color = "#DAD8D8", cterm_color = "188", name = "Sql" },
    [".DS_Store"] = { icon = "", color = "#FFF2F2", cterm_color = "255", name = "DsStore" },
    [".env.example"] = { icon = "", color = "#FAF743", cterm_color = "227", name = "Env" },
    [".env.sample"] = { icon = "", color = "#FAF743", cterm_color = "227", name = "Env" },
    [".env.test"] = { icon = "", color = "#FAF743", cterm_color = "227", name = "Env" },
    [".gitconfig"] = { icon = "", color = "#F54D27", cterm_color = "196", name = "GitIgnore" },
    [".gitignore-global"] = { icon = "", color = "#F54D27", cterm_color = "196", name = "GitIgnore" },
    [".python-version"] = { icon = "", color = "#6D8086", cterm_color = "66", name = "PyVersion" },
    [".stow-local-ignore"] = { icon = "", color = "#F54D27", cterm_color = "196", name = "GitIgnore" },
    [".vimiumrc"] = { icon = "", color = "#019833", cterm_color = "28", name = "Vim" },
    [".zshenv"] = { icon = "󱆃", color = "#89E051", cterm_color = "113", name = "Zshenv" },
    [".zshrc"] = { icon = "󱆃", color = "#89E051", cterm_color = "113", name = "Zshrc" },
    ["ignore"] = { icon = "", color = "#F54D27", cterm_color = "196", name = "GitIgnore" },
    ["LICENSE"] = { icon = "", color = "#D0BF41", cterm_color = "185", name = "License" },
    ["LICENSE.md"] = { icon = "", color = "#D0BF41", cterm_color = "185", name = "License" },
    ["LICENSE.txt"] = { icon = "", color = "#D0BF41", cterm_color = "185", name = "License" },
    ["Makefile"] = { icon = "", color = "#6D8086", cterm_color = "66", name = "Makefile" },
    ["pyproject.toml"] = { icon = "", color = "#9C4221", cterm_color = "124", name = "Pyproject" },
  },
  light = {
    [".aliases"] = { icon = "󱆃", color = "#526064", cterm_color = "59", name = "Aliases" },
    [".bash_aliases"] = { icon = "󱆃", color = "#526064", cterm_color = "59", name = "BashAliases" },
    [".coverage"] = { icon = "", color = "#494848", cterm_color = "238", name = "Sql" },
    [".DS_Store"] = { icon = "", color = "#333030", cterm_color = "236", name = "DsStore" },
    [".env.example"] = { icon = "", color = "#32310D", cterm_color = "236", name = "Env" },
    [".env.sample"] = { icon = "", color = "#32310D", cterm_color = "236", name = "Env" },
    [".env.test"] = { icon = "", color = "#32310D", cterm_color = "236", name = "Env" },
    [".gitconfig"] = { icon = "", color = "#B83A1D", cterm_color = "160", name = "GitIgnore" },
    [".gitignore-global"] = { icon = "", color = "#B83A1D", cterm_color = "160", name = "GitIgnore" },
    [".python-version"] = { icon = "", color = "#526064", cterm_color = "59", name = "PyVersion" },
    [".stow-local-ignore"] = { icon = "", color = "#B83A1D", cterm_color = "160", name = "GitIgnore" },
    [".vimiumrc"] = { icon = "", color = "#017226", cterm_color = "22", name = "Vim" },
    [".zshenv"] = { icon = "󱆃", color = "#447028", cterm_color = "22", name = "Zshenv" },
    [".zshrc"] = { icon = "󱆃", color = "#447028", cterm_color = "22", name = "Zshrc" },
    ["ignore"] = { icon = "", color = "#B83A1D", cterm_color = "160", name = "GitIgnore" },
    ["LICENSE"] = { icon = "", color = "#686020", cterm_color = "58", name = "License" },
    ["LICENSE.md"] = { icon = "", color = "#686020", cterm_color = "58", name = "License" },
    ["LICENSE.txt"] = { icon = "", color = "#686020", cterm_color = "58", name = "License" },
    ["Makefile"] = { icon = "", color = "#526064", cterm_color = "59", name = "Makefile" },
    ["pyproject.toml"] = { icon = "", color = "#753219", cterm_color = "88", name = "Pyproject" },
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
