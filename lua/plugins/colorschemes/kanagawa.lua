-- Kanagawa.nvim
--
-- NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.

local theme = require("theme")

return {
  "rebelot/kanagawa.nvim",
  lazy = theme.get_lazyness("kanagawa"),
  priority = 1000,
  opts = theme.make_opts("kanagawa", {
    keywordStyle = { italic = false },
    transparent = true,
  }),
  config = function(_, opts)
    require("kanagawa").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("kanagawa")
  end,
}
