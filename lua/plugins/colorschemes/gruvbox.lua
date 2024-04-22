-- gruvbox.nvim
--
-- A port of gruvbox community theme to lua with treesitter and semantic highlights support.

local ok, theme = pcall(require, "theme") -- Handle the case the theme file is missing
if not ok then
  theme = {}
end

return {
  "ellisonleao/gruvbox.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.gruvbox_enabled or false), -- By default, don't enable color schemes
  priority = 1000,
  opts = vim.tbl_deep_extend("force", {
    transparent_mode = true,
  }, theme.gruvbox_opts or {}),
  config = function(_, opts)
    require("gruvbox").setup(opts) -- setup must be called before loading

    local gruvbox_background = theme.gruvbox_background or "dark"
    vim.o.background = gruvbox_background
    vim.cmd.colorscheme("gruvbox")

    -- Fix inconsistent highlight groups for Neogit (foreground color is either white or red
    -- for diffs when they are in context or not)
    -- Default highlight groups for Neogit with this color scheme are:
    --   DiffAddxxx guibg=#62693e (linked to NeogitDiffAdd)
    --   NeogitDiffAddHighlight cterm= gui= guifg=#b8bb26 guibg=#62693e
    --   DiffDelete guibg=#722529 (linked to NeogitDiffDelete)
    --   NeogitDiffDeleteHighlight cterm= gui= guifg=#fb4934 guibg=#722529
    -- Let's make the non-highlight groups same as the highlight ones
    vim.api.nvim_command("hi NeogitDiffAdd guifg=#b8bb26 guibg=#62693e")
    vim.api.nvim_command("hi NeogitDiffDelete guifg=#fb4934 guibg=#722529")
  end,
}
