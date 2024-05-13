-- Rosé Pine
--
-- All natural pine, faux fur and a bit of soho vibes for the classy minimalist.

local theme = require("theme")

return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = theme.get_lazyness("rose_pine"),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = theme.make_opts("rose_pine", {
    variant = "main",
    styles = { transparency = true },
  }),
  config = function(_, opts)
    require("rose-pine").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("rose-pine")
  end,
}
