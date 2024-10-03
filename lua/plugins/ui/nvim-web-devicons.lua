-- nvim-web-devicons
--
-- A Lua fork of vim-devicons, providing icons as well as colors for each icon, in both dark and light modes. This
-- plugin is a very standard plugin to use, as it is used by many other plugins, to provide many user-friendly and
-- customizable icons out-of-the-box.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Only used by many plugins as a dpendency
  opts = {
    override_by_filename = require("filetypes").icon_by_filename, -- Add custom icons
  },
}
