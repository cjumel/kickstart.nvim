return {
  "folke/tokyonight.nvim",
  cond = MetaConfig.enable_all_plugins or ThemeConfig.tokyonight_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    style = ThemeConfig.tokyonight_style or "night",
    transparent = true,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("tokyonight")
  end,
}
