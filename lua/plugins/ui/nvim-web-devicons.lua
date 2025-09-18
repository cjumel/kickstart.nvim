local extra_filename_to_icon_name = {
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

-- Generally defined using exising icons data, with:
-- `:lua print(require("nvim-web-devicons").get_icon_colors("<icon-name>"))`
local extra_icon_names_to_icon_data = {
  [".env"] = {
    icon = "",
    color = "#faf743",
    cterm_color = "227",
    name = ".env",
    _color_light = "#32310d",
    _cterm_color_light = "236",
  },
  [".gitignore"] = {
    icon = "",
    color = "#f54d27",
    cterm_color = "196",
    name = ".gitignore",
    _color_light = "#b83a1d",
    _cterm_color_light = "160",
  },
  [".python-version"] = {
    icon = "",
    color = "#458ee6",
    cterm_color = "68",
    name = ".python-version",
    _color_light = "#805e02",
    _cterm_color_light = "94",
  },
  ["vim"] = {
    icon = "",
    color = "#019833",
    cterm_color = 28,
    name = "vim",
    _color_light = "#017226",
    _cterm_color_light = "22",
  },
}

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Only used by many plugins as a dpendency
  opts = function()
    local background = ThemeConfig.background or "dark"
    local override_by_filename = {}
    for filename, filetype in pairs(extra_filename_to_icon_name) do
      local icon_data = extra_icon_names_to_icon_data[filetype]
      if background == "light" then
        icon_data.color = icon_data._color_light and icon_data._color_light or icon_data.color
        icon_data.cterm_color = icon_data._cterm_color_light and icon_data._cterm_color_light or icon_data.cterm_color
      end
      override_by_filename[filename] = icon_data
    end
    return { override_by_filename = override_by_filename } -- Icon customization by filename
  end,
}
