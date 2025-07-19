-- Sonokai
--
-- High Contrast & Vivid Color Scheme based on Monokai Pro.

return {
  "sainnhe/sonokai",
  cond = MetaConfig.enable_all_plugins or ThemeConfig.sonokai_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.sonokai_transparent_background = true
    vim.cmd.colorscheme("sonokai")
  end,
}
