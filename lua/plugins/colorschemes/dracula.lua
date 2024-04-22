-- dracula.nvim
--
-- Dracula color scheme for Neovim written in Lua.

local ok, theme = pcall(require, "theme") -- Handle the case the theme file is missing
if not ok then
  theme = {}
end

return {
  "Mofiqul/dracula.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.dracula_enabled or false), -- By default, don't enable color schemes
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    transparent_bg = true,
  }, theme.dracula_opts or {}),
  config = function(_, opts)
    require("dracula").setup(opts)
    vim.cmd.colorscheme("dracula")

    -- Fix hard-to-read highlight groups for Neogit (foreground color hasn't enought contrast)
    -- Default highlight groups for Neogit with this color scheme are:
    --   NeogitDiffAddxxx cterm= gui= guifg=#c6cd73 guibg=#50fa7b
    --   NeogitDiffAddHighlightxxx cterm= gui= guifg=#f1fa8c guibg=#50fa7b
    -- Let's make the highlight group foreground color use darker greens
    vim.api.nvim_command("hi NeogitDiffAdd guifg=#00a300 guibg=#50fa7b")
    vim.api.nvim_command("hi NeogitDiffAddHighlight guifg=#006400 guibg=#50fa7b")
  end,
}
