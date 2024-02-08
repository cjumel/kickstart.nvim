-- Nord.nvim
--
-- Neovim theme based off of the Nord Color Palette.

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {}
end

return {
  "shaunsingh/nord.nvim",
  enabled = theme.nord_enabled or false, -- By default, don't enable color schemes
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.nord_disable_background = true -- Enable transparent background
    vim.cmd.colorscheme("nord")
  end,
}
