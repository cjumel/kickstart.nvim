return {
  "rebelot/kanagawa.nvim",
  cond = vim.env["NVIM_ENABLE_ALL_PLUGINS"] or ThemeConfig.kanagawa_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = { transparent = true },
  config = function(_, opts)
    require("kanagawa").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("kanagawa-" .. (ThemeConfig.kanagawa_style or "wave"))
  end,
}
