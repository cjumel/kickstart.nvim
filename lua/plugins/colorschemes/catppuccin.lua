-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including neovim, and defining
-- different tones from light to dark.

local ok, theme = pcall(require, "theme") -- Handle the case the theme file is missing
if not ok then
  theme = { catppuccin_enabled = true } -- If the theme file is missing, use this one as default
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  -- If plugin is not enabled, just make it lazy to avoid changing the lazy lock file
  lazy = not (theme.catppuccin_enabled or false), -- By default, don't enable color schemes
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true,
    integrations = { -- add highlight groups for popular plugins
      harpoon = true,
      hop = true,
      mason = true,
      noice = true,
      notify = true,
      overseer = true,
      lsp_trouble = true,
      which_key = true,
    },
  }, theme.catppuccin_opts or {}),
  config = function(_, opts)
    require("catppuccin").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
