-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including Neovim, and defining different tones from light
-- to dark. It is one of the most popular color schemes for Neovim, and has many features and integrations available,
-- hence it is one of the color schemes I use.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  cond = require("theme").get_field("catppuccin", "enabled", false),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = require("theme").make_opts("catppuccin", {
    flavour = "mocha", -- "latte", "frappe", "macchiato", "mocha"
    transparent_background = true, -- Don't set a background color
    integrations = { -- Add highlight groups for additional plugins
      dadbod_ui = true,
      diffview = true,
      grug_far = true,
      harpoon = true,
      hop = true,
      mason = true,
      noice = true,
      notify = true,
      nvim_surround = true,
      overseer = true,
      lsp_trouble = true,
      which_key = true,
    },
  }),
  config = function(_, opts)
    local catppuccin = require("catppuccin")

    catppuccin.setup(opts) -- Setup must be called before loading the color scheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
