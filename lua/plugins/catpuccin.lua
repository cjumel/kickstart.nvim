-- catpuccin
--
-- Catpuccin is a color scheme defining different tones as flavors.

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- UI stuff should be loaded first
  config = function()
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
