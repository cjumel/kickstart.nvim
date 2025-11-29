return {
  "ellisonleao/gruvbox.nvim",
  cond = vim.env["NVIM_ENABLE_ALL_PLUGINS"] or ThemeConfig.gruvbox_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = { transparent_mode = true },
  config = function(_, opts)
    require("gruvbox").setup(opts) -- Must be called before loading the color scheme
    vim.opt.background = ThemeConfig.gruvbox_style or "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}
