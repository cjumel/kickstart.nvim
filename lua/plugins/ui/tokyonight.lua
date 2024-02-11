-- Tokyo Night
--
-- A dark and light Neovim theme written in Lua ported from the Visual Studio Code TokyoNight theme.

local theme = require("theme")

return {
  "folke/tokyonight.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.tokyonight_enabled or false), -- By default, don't enable color schemes
  priority = 1000,
  opts = theme.tokyonight_opts,
  config = function(_, opts)
    require("tokyonight").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("tokyonight")
  end,
}
