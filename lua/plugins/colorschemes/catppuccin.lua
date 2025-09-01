return {
  "catppuccin/nvim",
  name = "catppuccin",
  cond = MetaConfig.enable_all_plugins or ThemeConfig.catppuccin_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    flavour = ThemeConfig.catppuccin_style or "mocha",
    transparent_background = true,
    integrations = {
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
  },
  config = function(_, opts)
    require("catppuccin").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
