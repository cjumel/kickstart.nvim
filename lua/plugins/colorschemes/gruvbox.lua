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
  end,
}
