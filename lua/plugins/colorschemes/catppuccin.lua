return {
  "catppuccin/nvim",
  name = "catppuccin",
  cond = MetaConfig.enable_all_plugins or ThemeConfig.catppuccin_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    flavour = ThemeConfig.catppuccin_style or "mocha",
    transparent_background = true,
    float = { solid = true },
    default_integrations = false,
    integrations = {
      gitsigns = true,
      grug_far = true,
      harpoon = true,
      hop = true,
      indent_blankline = { enabled = true },
      markdown = true,
      mason = true,
      neogit = true,
      neotest = true,
      noice = true,
      cmp = true,
      dap = true,
      dap_ui = true,
      native_lsp = { enabled = true, virtual_text = {}, underlines = {} },
      semantic_tokens = true,
      nvim_surround = true,
      treesitter_context = true,
      treesitter = true,
      overseer = true,
      render_markdown = true,
      snacks = { enabled = true },
      lsp_trouble = true,
      dadbod_ui = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
