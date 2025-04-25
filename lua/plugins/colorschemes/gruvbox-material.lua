-- Gruvbox Material
--
-- Gruvbox with Material Palette.

return {
  "sainnhe/gruvbox-material",
  cond = Metaconfig.enable_all_plugins or Theme.gruvbox_material_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.gruvbox_material_transparent_background = true
    vim.cmd.colorscheme("gruvbox-material")
  end,
}
