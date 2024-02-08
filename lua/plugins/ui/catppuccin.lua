-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including neovim, and defining
-- different tones from light to dark.

local utils = require("utils")

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
if not ok then
  theme = {
    -- If the theme file is missing, use this as default color scheme otherwise there is none
    catppuccin_enabled = true,
  }
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = theme.catppuccin_enabled or false, -- By default, don't enable color schemes
  priority = 1000, -- Main UI stuff should be loaded first
  opts = utils.table.concat_dicts({
    {
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
    },
    theme.catppuccin_opts or {},
  }),
  config = function(_, opts)
    require("catppuccin").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
