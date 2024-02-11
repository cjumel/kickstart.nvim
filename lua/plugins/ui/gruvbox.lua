-- gruvbox.nvim
--
-- A port of gruvbox community theme to lua with treesitter and semantic highlights support.

local theme = require("theme")

return {
  "ellisonleao/gruvbox.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.gruvbox_enabled or false), -- By default, don't enable color schemes
  priority = 1000,
  opts = theme.gruvbox_opts,
  config = function(_, opts)
    require("gruvbox").setup(opts) -- setup must be called before loading
    if theme.gruvbox_background == "light" then
      vim.o.background = "light"
    else
      vim.o.background = "dark"
    end
    vim.cmd.colorscheme("gruvbox")
  end,
}
