-- nordic.nvim
--
-- Neovim theme based off the Nord color palette, but with warmer and darker colors than the original theme..

return {
  "AlexvZyl/nordic.nvim",
  cond = Theme.nordic_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = { transparent = { bg = true } },
  config = function(_, opts)
    require("nordic").setup(opts) -- Must be called before loading the color scheme
    require("nordic").load()
  end,
}
