-- Nord.nvim
--
-- Neovim theme based off of the Nord Color Palette.

local utils = require("utils")

return {
  "shaunsingh/nord.nvim",
  lazy = utils.theme.get_lazyness("nord"),
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.nord_disable_background = true -- Enable transparent background
    vim.cmd.colorscheme("nord")

    -- Fix unreadable highlight groups for Neogit (background & foreground are the same on highlighted sections)
    -- Let's change the foreground color of these groups to use the colors taken from Gruvbox (dark)
    vim.api.nvim_command("hi NeogitDiffAddHighlight gui=reverse guibg=#62693e")
    vim.api.nvim_command("hi NeogitDiffDeleteHighlight gui=reverse guibg=#722529")
  end,
}
