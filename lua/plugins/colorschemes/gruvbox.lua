-- gruvbox.nvim
--
-- A port of gruvbox community theme to lua with treesitter and semantic highlights support.

local theme = require("theme")

return {
  "ellisonleao/gruvbox.nvim",
  lazy = theme.get_lazyness("gruvbox"),
  priority = 1000,
  opts = theme.make_opts("gruvbox", {
    transparent_mode = true,
  }),
  config = function(_, opts)
    require("gruvbox").setup(opts) -- setup must be called before loading

    vim.o.background = theme.get_field("gruvbox", "background") or "dark"
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
