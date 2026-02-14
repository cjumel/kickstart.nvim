return {
  "navarasu/onedark.nvim",
  cond = vim.env["NVIM_ENABLE_ALL_PLUGINS"] or ThemeConfig.colorscheme_name == "onedark",
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    transparent = true,
  }, ThemeConfig.colorscheme_opts or {}),
  config = function(_, opts)
    require("onedark").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("onedark")
  end,
}
