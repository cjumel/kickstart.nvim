-- Ashen
--
-- A warm, muted colorscheme for Neovim featuring red, orange, plenty of grayscale.

local theme = require("theme")

return {
  "ficcdaf/ashen.nvim",
  cond = theme.ashen_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    transparent = true,
  }, theme.ashen_opts or {}),
  config = function(_, opts)
    require("ashen").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("ashen")
  end,
}
