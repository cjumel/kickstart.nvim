-- Everforest
--
-- Green based color, comfortable and pleasant color scheme for Neovim.

return {
  "sainnhe/everforest",
  cond = Theme.everforest_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.everforest_transparent_background = true
    vim.cmd.colorscheme("everforest")
  end,
}
