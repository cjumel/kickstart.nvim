-- gruvbox
--
-- This is a port of the gruvbox community theme to Neovim, providing retro groove colors. This color scheme is very
-- simple and provides a nice old-school theme, even if it doesn't have as much features and integrations as more
-- popular color schemes.

return {
  "ellisonleao/gruvbox.nvim",
  cond = MetaConfig.enable_all_plugins or ThemeConfig.gruvbox_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = { transparent_mode = true },
  config = function(_, opts)
    require("gruvbox").setup(opts) -- Must be called before loading the color scheme
    vim.o.background = ThemeConfig.gruvbox_style or "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}
