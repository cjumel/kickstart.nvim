-- nord.nvim
--
-- Neovim theme based off the Nord color palette, for blueish color lovers.

return {
  "shaunsingh/nord.nvim",
  cond = require("theme").nord_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.nord_disable_background = true -- Don't set a background color
    vim.cmd.colorscheme("nord") -- Options must be set before loading the color scheme
  end,
}
