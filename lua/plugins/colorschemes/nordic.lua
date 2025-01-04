-- nordic.nvim
--
-- Neovim theme based off the Nord color palette, but with warmer and darker colors than the original theme..

return {
  "AlexvZyl/nordic.nvim",
  cond = require("theme").nordic_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    transparent = { bg = true },
  },
  config = function(_, opts)
    require("nordic").setup(opts)
    require("nordic").load()
  end,
}
