-- OneDark.nvim
--
-- Theme for Neovim based on Atom One Dark theme written in lua with TreeSitter syntax highlight.

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {}
end

return {
  "navarasu/onedark.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.onedark_enabled or false), -- By default, don't enable color schemes
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    transparent = true,
  },
  config = function(_, opts)
    local onedark = require("onedark")
    onedark.setup(opts)
    onedark.load()
  end,
}
