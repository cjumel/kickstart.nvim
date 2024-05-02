-- Nord.nvim
--
-- Neovim theme based off of the Nord Color Palette.

local ok, theme = pcall(require, "theme") -- Handle the case the theme file is missing
if not ok then
  theme = {}
end

return {
  "shaunsingh/nord.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.nord_enabled or false), -- By default, don't enable color schemes
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
