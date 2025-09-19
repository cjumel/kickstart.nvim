local extra_filename_to_icon_name = {
  [".coverage"] = "sqlite3",
  [".env.example"] = ".env",
  [".env.sample"] = ".env",
  [".env.test"] = ".env",
  [".env.test.example"] = ".env",
  [".gitignore-global"] = ".gitignore",
  [".python-version"] = ".python-version",
  [".stow-local-ignore"] = ".gitignore",
  [".vimiumrc"] = "vim",
  ["ignore"] = ".gitignore",
}

-- Default icon data can be found in:
-- https://github.com/nvim-tree/nvim-web-devicons/tree/master/lua/nvim-web-devicons/default
-- https://github.com/nvim-tree/nvim-web-devicons/tree/master/lua/nvim-web-devicons/light
local extra_icon_names_to_icon_data = {
  dark = {
    [".env"] = { icon = "", color = "#FAF743", cterm_color = "227", name = "Env" },
    [".gitignore"] = { icon = "", color = "#F54D27", cterm_color = "196", name = "GitIgnore" },
    [".python-version"] = { icon = "", color = "#458ee6", cterm_color = "68", name = "PyVersion" },
    ["sqlite3"] = { icon = "", color = "#DAD8D8", cterm_color = "188", name = "Sql" },
    ["vim"] = { icon = "", color = "#019833", cterm_color = "28", name = "Vim" },
  },
  light = {
    [".env"] = { icon = "", color = "#32310D", cterm_color = "236", name = "Env" },
    [".gitignore"] = { icon = "", color = "#B83A1D", cterm_color = "160", name = "GitIgnore" },
    [".python-version"] = { icon = "", color = "#805e02", cterm_color = "94", name = "PyVersion" },
    ["sqlite3"] = { icon = "", color = "#494848", cterm_color = "238", name = "Sql" },
    ["vim"] = { icon = "", color = "#017226", cterm_color = "22", name = "Vim" },
  },
}

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Only used by many plugins as a dpendency
  opts = function()
    local background = ThemeConfig.background or "dark"
    local override_by_filename = {}
    for filename, icon_name in pairs(extra_filename_to_icon_name) do
      override_by_filename[filename] = extra_icon_names_to_icon_data[background][icon_name]
    end
    return {
      override_by_filename = override_by_filename, -- Icon customization by filename
    }
  end,
}
