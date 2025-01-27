-- kanagawa.nvim
--
-- kanagawa.nvim is a Neovim color scheme inspired by the colors of the famous painting by Katsushika Hokusai. I find it
-- to be one of the prettiest colors cheme for Neovim, despite having less features and integrations than other popular
-- colors chemes.

return {
  "rebelot/kanagawa.nvim",
  cond = Theme.kanagawa_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = { transparent = true },
  config = function(_, opts)
    require("kanagawa").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("kanagawa-" .. (Theme.kanagawa_style or "wave"))
  end,
}
