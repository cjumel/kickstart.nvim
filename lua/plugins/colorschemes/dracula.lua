-- dracula.nvim
--
-- Dracula color scheme for Neovim written in Lua.

local theme = require("theme")

return {
  "Mofiqul/dracula.nvim",
  lazy = theme.get_lazyness("dracula"),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = theme.make_opts("dracula", {
    transparent_bg = true,
  }),
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
