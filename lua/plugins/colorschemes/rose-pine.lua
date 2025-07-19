-- Rosé Pine
--
-- Plugin providing all natural pine, faux fur and a bit of soho vibes for the classy minimalist. It is maybe the most
-- popular minimalist color scheme for Neovim, and provides many features and integrations.

return {
  "rose-pine/neovim",
  name = "rose-pine",
  cond = MetaConfig.enable_all_plugins or ThemeConfig.rose_pine_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    variant = ThemeConfig.rose_pine_style or "main",
    styles = { transparency = true },
  },
  config = function(_, opts)
    require("rose-pine").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("rose-pine")
  end,
}
