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
      desc = "[Z]en mode: toggle",
    },
  },
  opts = {
    window = {
      backdrop = 1, -- No difference between the background and the window
      width = 100,
      options = {
        signcolumn = "no", -- Disable sign column
        number = false, -- Disable number column
      },
    },
    plugins = {
      twilight = { enabled = false }, -- Disable Twilight by default
      tmux = { enabled = true }, -- Disable Tmux status line
    },
  },
}
