-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including neovim, and defining different tones from light
-- to dark.

local theme = require("theme")

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = theme.get_lazyness("catppuccin"),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = theme.make_opts("catppuccin", {
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true,
    integrations = { -- add highlight groups for popular plugins
      harpoon = true,
      headlines = true,
      hop = true,
      mason = true,
      noice = true,
      notify = true,
      overseer = true,
      lsp_trouble = true,
      which_key = true,
    },
  }),
  config = function(_, opts)
    require("catppuccin").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
