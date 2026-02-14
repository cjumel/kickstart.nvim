return {
  "rose-pine/neovim",
  name = "rose-pine",
  cond = vim.env["NVIM_ENABLE_ALL_PLUGINS"] or ThemeConfig.colorscheme_name == "rose-pine",
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    styles = { transparency = true },
  }, ThemeConfig.colorscheme_opts or {}),
  config = function(_, opts)
    require("rose-pine").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("rose-pine")
  end,
}
