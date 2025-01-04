-- Rosé Pine
--
-- Plugin providing all natural pine, faux fur and a bit of soho vibes for the classy minimalist. It is maybe the most
-- popular minimalist color scheme for Neovim, and provides many features and integrations.

return {
  "rose-pine/neovim",
  name = "rose-pine",
  cond = require("theme").rose_pine_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    variant = "main", -- "auto", "main", "moon", or "dawn"
    styles = { transparency = true },
  }, require("theme").rose_pine_opts or {}),
  config = function(_, opts)
    local rose_pine = require("rose-pine")

    rose_pine.setup(opts) -- Setup must be called before loading the color scheme
    vim.cmd.colorscheme("rose-pine")
  end,
}
