-- Rosé Pine
--
-- Plugin providing all natural pine, faux fur and a bit of soho vibes for the classy minimalist. It is maybe the most
-- popular minimalist color scheme for Neovim, and provides many features and integrations.

local theme = require("theme")

return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = theme.get_lazyness("rose_pine"),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = theme.make_opts("rose_pine", {
    variant = "main", -- "auto", "main", "moon", or "dawn"
    styles = { transparency = true }, -- Don't set a background color
  }),
  config = function(_, opts)
    local rose_pine = require("rose-pine")

    rose_pine.setup(opts) -- Setup must be called before loading the color scheme
    vim.cmd.colorscheme("rose-pine")
  end,
}
