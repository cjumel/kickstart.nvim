-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including Neovim, and defining different tones from light
-- to dark. It is one of the most popular color schemes for Neovim, and has many features and integrations available,
-- hence it is one of the color schemes I use.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  cond = require("theme").catppuccin_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    flavour = "mocha", -- "latte", "frappe", "macchiato", "mocha"
    transparent_background = true,
    integrations = { -- Add highlight groups for additional plugins
      aerial = true,
      dadbod_ui = true,
      grug_far = true,
      hop = true,
      mason = true,
      noice = true,
      notify = true,
      nvim_surround = true,
      overseer = true,
      lsp_trouble = true,
      snacks = true,
      which_key = true,
    },
  }, require("theme").catppuccin_opts or {}),
  config = function(_, opts)
    require("catppuccin").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
