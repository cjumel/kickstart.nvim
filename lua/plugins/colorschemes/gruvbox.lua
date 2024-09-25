-- gruvbox
--
-- This is a port of the gruvbox community theme to Neovim, providing retro groove colors. This color scheme is very
-- simple and provides a nice old-school theme, even if it doesn't have as much features and integrations as more
-- popular color schemes.

return {
  "ellisonleao/gruvbox.nvim",
  cond =  require("theme").get_field("gruvbox", "enabled", false),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = require("theme").make_opts("gruvbox", {
    transparent_mode = true, -- Don't set a background color
  }),
  config = function(_, opts)
    local gruvbox = require("gruvbox")

    gruvbox.setup(opts) -- Setup must be called before loading the color scheme
    vim.o.background = require("theme").get_field("gruvbox", "background", "dark")
    vim.cmd.colorscheme("gruvbox")
  end,
}
