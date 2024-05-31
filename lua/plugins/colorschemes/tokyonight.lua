-- Tokyo Night
--
-- A dark and light Neovim theme written in Lua ported from the Visual Studio Code TokyoNight theme.

local theme = require("theme")

return {
  "folke/tokyonight.nvim",
  lazy = theme.get_lazyness("tokyonight"),
  priority = 1000,
  opts = theme.make_opts("tokyonight", {
    style = "night", -- night, moon, storm or day
    transparent = true,
  }),
  config = function(_, opts)
    require("tokyonight").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("tokyonight")
  end,
}
