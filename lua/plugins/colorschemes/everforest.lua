return {
  "sainnhe/everforest",
  cond = MetaConfig.enable_all_plugins or ThemeConfig.everforest_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.everforest_transparent_background = true
    vim.cmd.colorscheme("everforest")
  end,
}
