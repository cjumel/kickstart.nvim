-- nvim-web-devicons
--
-- A Lua fork of vim-devicons, providing icons as well as colors for each icon. This plugin is used by many other
-- plugins, to provide user-friendly and customizable icons.

-- BUG: custom icons (using `set_icon`) stopped working I believe when upgrading nvim to 0.10
--  This is likely the same issue as https://github.com/nvim-tree/nvim-web-devicons/issues/465

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Dependency of several plugins
  opts = {}, -- Custom filetype settings are done in `plugins/filetypes.lua`
}
