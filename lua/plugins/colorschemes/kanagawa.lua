-- kanagawa.nvim
--
-- kanagawa.nvim is a Neovim color scheme inspired by the colors of the famous painting by Katsushika Hokusai. I find it
-- to be one of the prettiest colors cheme for Neovim, despite having less features and integrations than other popular
-- colors chemes.

local theme = require("theme")

return {
  "rebelot/kanagawa.nvim",
  lazy = theme.get_lazyness("kanagawa"),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = theme.make_opts("kanagawa", {
    transparent = true, -- Don't set a background color
  }),
  config = function(_, opts)
    local kanagawa = require("kanagawa")

    kanagawa.setup(opts) -- Setup must be called before loading the color scheme
    local kanagawa_theme = opts.theme or "wave"
    vim.cmd.colorscheme("kanagawa-" .. kanagawa_theme)
  end,
}
