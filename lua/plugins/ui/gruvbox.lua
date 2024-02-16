-- gruvbox.nvim
--
-- A port of gruvbox community theme to lua with treesitter and semantic highlights support.

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {}
end

return {
  "ellisonleao/gruvbox.nvim",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.gruvbox_enabled or false), -- By default, don't enable color schemes
  priority = 1000,
  opts = {
    transparent_mode = true,
  },
  config = function(_, opts)
    require("gruvbox").setup(opts) -- setup must be called before loading

    local gruvbox_background = theme.gruvbox_background or "dark"
    vim.o.background = gruvbox_background
    vim.cmd.colorscheme("gruvbox")
  end,
}
