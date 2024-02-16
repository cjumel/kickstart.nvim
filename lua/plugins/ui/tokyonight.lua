-- Tokyo Night
--
-- A dark and light Neovim theme written in Lua ported from the Visual Studio Code TokyoNight theme.

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {}
end

return {
  "folke/tokyonight.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.tokyonight_enabled or false), -- By default, don't enable color schemes
  priority = 1000,
  opts = {
    style = "night", -- night, moon, storm or day
    transparent = true,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("tokyonight")
  end,
}
