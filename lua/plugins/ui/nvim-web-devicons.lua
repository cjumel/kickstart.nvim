-- nvim-web-devicons
--
-- A Lua fork of vim-devicons, providing icons as well as colors for each icon, in both dark and light modes. This
-- plugin is a very standard plugin to use, as it is used by many other plugins, to provide many user-friendly and
-- customizable icons out-of-the-box.

-- Icon data is defined using the command `lua print(require("nvim-web-devicons").get_icon_colors("<icon-name>"))`
local icon_names_to_icon_data = {
  [".env"] = { icon = "", color = "#faf743", cterm_color = "227", name = ".env" },
  ["conf"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  ["ignore"] = { icon = "", color = "#51a0cf", cterm_color = 74, name = "ignore" },
  ["json"] = { icon = "", color = "#cbcb41", cterm_color = 185, name = "json" },
  ["tmux"] = { icon = "", color = "#14ba19", cterm_color = "34", name = "tmux" },
  ["vim"] = { icon = "", color = "#019833", cterm_color = 28, name = "vim" },
}

local override_by_filename = {}
for filename, filetype in pairs(Metaconfig.extra_filename_to_icon_name or {}) do
  override_by_filename[filename] = icon_names_to_icon_data[filetype]
end

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Only used by many plugins as a dpendency
  opts = { override_by_filename = override_by_filename }, -- Icon customization by filename
}
