-- nvim-web-devicons
--
-- A Lua fork of vim-devicons, providing icons as well as colors for each icon, in both dark and light modes. This
-- plugin is a very standard plugin to use, as it is used by many other plugins, to provide many user-friendly and
-- customizable icons out-of-the-box.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Only used by many plugins as a dpendency
  opts = function()
    local background = ThemeConfig.background or "dark"
    local extra_filename_to_icon_name = MetaConfig.extra_filename_to_icon_name or {}
    local icon_names_to_icon_data = MetaConfig.extra_icon_names_to_icon_data or {}

    local override_by_filename = {}
    for filename, filetype in pairs(extra_filename_to_icon_name) do
      local icon_data = icon_names_to_icon_data[filetype]
      if background == "light" then
        icon_data.color = icon_data._color_light and icon_data._color_light or icon_data.color
        icon_data.cterm_color = icon_data._cterm_color_light and icon_data._cterm_color_light or icon_data.cterm_color
      end
      override_by_filename[filename] = icon_data
    end

    return { override_by_filename = override_by_filename } -- Icon customization by filename
  end,
}
