-- catpuccin
--
-- Catpuccin is a color scheme defining different tones as flavors.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- UI stuff should be loaded first
  config = function()
    -- setup must be called before loading
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
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
