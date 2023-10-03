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
      transparent_background = true, -- disables setting the background color.
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
