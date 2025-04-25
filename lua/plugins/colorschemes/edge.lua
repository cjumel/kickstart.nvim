-- Edge
--
-- Clean & Elegant Color Scheme inspired by Atom One and Material.

return {
  "sainnhe/edge",
  cond = Metaconfig.enable_all_plugins or Theme.edge_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.edge_transparent_background = true
    vim.cmd.colorscheme("edge")
  end,
}
