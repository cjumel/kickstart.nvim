-- Nord.nvim
--
-- Neovim theme based off of the Nord Color Palette.

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
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

    -- Fix unreadable Neogit highlight groups with this color scheme
    -- Default highlight groups with this color scheme are:
    --   NeogitDiffAdd guifg=#a3be8c guibg=#a3be8c
    --   NeogitDiffAddHighlight gui=reverse guifg=#a3be8c
    --   NeogitDiffDelete guifg=#bf616a
    --   NeogitDiffDeleteHighlight gui=reverse guifg=#bf616a
    -- Let's use the same colors with a black foreground
    vim.api.nvim_command("hi NeogitDiffAdd guifg=#000000 guibg=#a3be8c")
    vim.api.nvim_command("hi NeogitDiffAddHighlight guibg=#000000 guifg=#a3be8c") -- reversed
    vim.api.nvim_command("hi NeogitDiffDelete guifg=#000000 guibg=#bf616a")
    vim.api.nvim_command("hi NeogitDiffDeleteHighlight guibg=#000000 guifg=#bf616a") -- reversed
  end,
}
