-- Rosé Pine
--
-- All natural pine, faux fur and a bit of soho vibes for the classy minimalist.

local ok, theme = pcall(require, "theme") -- Handle the case the theme file is missing
if not ok then
  theme = {}
end

return {
  "rose-pine/neovim",
  name = "rose-pine",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.rose_pine_enabled or false), -- By default, don't enable color schemes
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    variant = "main",
    styles = { transparency = true },
  }, theme.rose_pine_opts or {}),
  config = function(_, opts)
    require("rose-pine").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("rose-pine")
  end,
}
