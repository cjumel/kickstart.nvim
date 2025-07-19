-- nord.nvim
--
-- An arctic, north-bluish clean and elegant Neovim theme.

return {
  "gbprod/nord.nvim",
  cond = MetaConfig.enable_all_plugins or ThemeConfig.nord_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = { transparent = true },
  config = function(_, opts)
    require("nord").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("nord")
  end,
}
