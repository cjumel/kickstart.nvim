-- Kanagawa.nvim
--
-- NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {}
end

return {
  "rebelot/kanagawa.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.kanagawa_enabled or false), -- By default, don't enable color schemes
  priority = 1000,
  opts = {
    transparent = true,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("kanagawa")
  end,
}
