-- Tokyo Night
--
-- A dark and light Neovim theme written in Lua ported from the Visual Studio Code TokyoNight theme.

local ok, theme = pcall(require, "theme") -- Handle the case the theme file is missing
if not ok then
  theme = {}
end

return {
  "folke/tokyonight.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.tokyonight_enabled or false), -- By default, don't enable color schemes
  priority = 1000,
  opts = vim.tbl_deep_extend("force", {
    style = "night", -- night, moon, storm or day
    transparent = true,
  }, theme.tokyonight_opts or {}),
  config = function(_, opts)
    require("tokyonight").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("tokyonight")

    -- Improve highlight groups for Neogit (focused blocks have less intense colors as unfocused
    -- ones)
    -- Default highlight groups for Neogit with this color scheme are:
    --   NeogitDiffAddxxx cterm= gui= guifg=#82a957 guibg=#20303b
    --   NeogitDiffAddHighlightxxx guifg=#449dab guibg=#20303b
    --   NeogitDiffDeletexxx cterm= gui= guifg=#b43e3e guibg=#37222c
    --   NeogitDiffDeleteHighlightxxx guifg=#914c54 guibg=#37222c
    -- Let's make the focused blocks the same as the unfocused ones:
    vim.api.nvim_command("hi NeogitDiffAddHighlight guifg=#82a957 guibg=#20303b")
    vim.api.nvim_command("hi NeogitDiffDeleteHighlight guifg=#b43e3e guibg=#37222c")
  end,
}
