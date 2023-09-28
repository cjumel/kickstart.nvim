-- Zen-mode
--
-- Zen mode, striped out of distractions, for Neovim.

return {
  "folke/zen-mode.nvim",
  keys = {
    {
      "<leader>z",
      function()
        require("zen-mode").toggle()
      end,
      desc = "[Z]en mode",
    },
  },
  opts = {
    window = {
      backdrop = 1, -- No difference between the background and the window
      options = {
        number = false, -- Disable number column
      },
    },
  },
}
