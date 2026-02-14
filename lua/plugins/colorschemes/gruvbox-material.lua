return {
  "sainnhe/gruvbox-material",
  cond = vim.env["NVIM_ENABLE_ALL_PLUGINS"] or ThemeConfig.colorscheme_name == "gruvbox-material",
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.gruvbox_material_transparent_background = true
    vim.cmd.colorscheme("gruvbox-material")
  end,
}
