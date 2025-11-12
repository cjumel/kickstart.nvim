return {
  "navarasu/onedark.nvim",
  cond = vim.env["NVIM_ENABLE_ALL_PLUGINS"] or ThemeConfig.onedark_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    style = ThemeConfig.onedark_style or "dark",
    transparent = true,
  },
  config = function(_, opts)
    require("onedark").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("onedark")
  end,
}
