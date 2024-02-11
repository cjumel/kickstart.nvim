-- Kanagawa.nvim
--
-- NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.

local theme = require("theme")

return {
  "rebelot/kanagawa.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.kanagawa_enabled or false), -- By default, don't enable color schemes
  priority = 1000,
  opts = theme.kanagawa_opts,
  config = function(_, opts)
    require("kanagawa").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("kanagawa")
  end,
}
