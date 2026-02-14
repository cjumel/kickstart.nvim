return {
  "catppuccin/nvim",
  name = "catppuccin",
  cond = vim.env["NVIM_ENABLE_ALL_PLUGINS"] or ThemeConfig.colorscheme_name == "catppuccin",
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    transparent_background = true,
    float = { solid = true },
    default_integrations = false,
    integrations = {
      blink_cmp = { style = "bordered" },
      gitsigns = true,
      grug_far = true,
      hop = true,
      indent_blankline = { enabled = true },
      mason = true,
      neogit = true,
      neotest = true,
      noice = true,
      dap = true,
      dap_ui = true,
      nvim_surround = true,
      treesitter = true,
      render_markdown = true,
      snacks = { enabled = true },
      lsp_trouble = true,
      which_key = true,
    },
  }, ThemeConfig.colorscheme_opts or {}),
  config = function(_, opts)
    require("catppuccin").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
