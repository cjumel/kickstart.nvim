-- dracula.nvim
--
-- Dracula color scheme for Neovim written in Lua.

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {}
end

return {
  "Mofiqul/dracula.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.dracula_enabled or false), -- By default, don't enable color schemes
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    transparent_bg = true,
  },
  config = function(_, opts)
    require("dracula").setup(opts)
    vim.cmd.colorscheme("dracula")
  end,
}
