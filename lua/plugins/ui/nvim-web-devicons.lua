-- nvim-web-devicons
--
-- A Lua fork of vim-devicons, providing icons as well as colors for each icon. This plugin is used by many other
-- plugins, to provide user-friendly and customizable icons.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Dependency of several plugins
  opts = {}, -- Custom filetype settings are done in `plugins/filetypes.lua`
}
