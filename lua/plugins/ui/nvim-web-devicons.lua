-- nvim-web-devicons
--
-- A Lua fork of vim-devicons, providing icons as well as colors for each icon. This plugin is used as a dependency of
-- many other plugins, to provide user-friendly and customizable icons.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = false, -- Dependency of several plugins not lazy loaded but let's make sure this is not lazy loaded
  opts = {}, -- Custom filetype settings are done in `plugins/filetypes.lua`
}
