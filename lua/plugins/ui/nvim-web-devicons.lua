-- nvim-web-devicons
--
-- A Lua fork of vim-devicons, providing icons as well as colors for each icon, in both dark and light modes. This
-- plugin is a very standard plugin to use, as it is used by many other plugins, to provide many user-friendly and
-- customizable icons out-of-the-box.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Only used by many plugins as a dpendency
  opts = function()
    local extra_filename_to_icon_name = Metaconfig.extra_filename_to_icon_name or {}
    local icon_names_to_icon_data = Metaconfig.extra_icon_names_to_icon_data or {}

    local override_by_filename = {}
    for filename, filetype in pairs(extra_filename_to_icon_name) do
      override_by_filename[filename] = icon_names_to_icon_data[filetype]
    end

    return { override_by_filename = override_by_filename } -- Icon customization by filename
  end,
}
