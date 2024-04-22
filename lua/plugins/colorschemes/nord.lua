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

    -- Fix unreadable highlight groups for Neogit (background & foreground are the same)
    -- Default highlight groups for Neogit with this color scheme are:
    --   NeogitDiffAdd guifg=#a3be8c guibg=#a3be8c
    --   NeogitDiffAddHighlight gui=reverse guifg=#a3be8c
    --   NeogitDiffDelete guifg=#bf616a
    --   NeogitDiffDeleteHighlight gui=reverse guifg=#bf616a
    -- Let's take some colors from the Gruvbox color scheme (dark):
    --   DiffAddxxx guibg=#62693e (linked to NeogitDiffAdd)
    --   NeogitDiffAddHighlight cterm= gui= guifg=#b8bb26 guibg=#62693e
    --   DiffDelete guibg=#722529 (linked to NeogitDiffDelete)
    --   NeogitDiffDeleteHighlight cterm= gui= guifg=#fb4934 guibg=#722529
    vim.api.nvim_command("hi NeogitDiffAdd guifg=#b8bb26 guibg=#62693e")
    vim.api.nvim_command("hi NeogitDiffAddHighlight guibg=#b8bb26 guifg=#62693e") -- reversed
    vim.api.nvim_command("hi NeogitDiffDelete guifg=#fb4934 guibg=#722529")
    vim.api.nvim_command("hi NeogitDiffDeleteHighlight guibg=#fb4934 guifg=#722529") -- reversed
  end,
}
