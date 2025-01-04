-- kanagawa.nvim
--
-- kanagawa.nvim is a Neovim color scheme inspired by the colors of the famous painting by Katsushika Hokusai. I find it
-- to be one of the prettiest colors cheme for Neovim, despite having less features and integrations than other popular
-- colors chemes.

return {
  "rebelot/kanagawa.nvim",
  cond = require("theme").kanagawa_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    transparent = true,
  }, require("theme").kanagawa_opts or {}),
  config = function(_, opts)
    require("kanagawa").setup(opts) -- Must be called before loading the color scheme
    local kanagawa_theme = opts.theme or "wave"
    vim.cmd.colorscheme("kanagawa-" .. kanagawa_theme)
  end,
}
