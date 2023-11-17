-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including neovim, and defining
-- different tones from light to dark.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000, -- Main UI stuff should be loaded first
  keys = {
    {
      "<leader>T",
      function()
        local opts = require("catppuccin").options
        if opts.transparent_background then
          opts.transparent_background = false
        else
          opts.transparent_background = true
        end
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
      end,
      desc = "[T]ransparency switch",
    },
  },
  config = function()
    -- setup must be called before loading
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      integrations = { -- add highlight groups for popular plugins
        fidget = true,
        harpoon = true,
        hop = true,
        mason = true,
        noice = true,
        notify = true,
        lsp_trouble = true,
        which_key = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
