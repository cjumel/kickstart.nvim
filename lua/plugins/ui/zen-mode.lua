-- Zen-mode
--
-- Zen mode, striped out of distractions, for Neovim.

return {
  "folke/zen-mode.nvim",
  keys = {
    {
      "<leader>z",
      function() require("zen-mode").toggle() end,
      desc = "[Z]en mode",
    },
  },
  opts = {
    window = {
      backdrop = 1, -- No difference between the background and the window
      width = 126, -- Base width (120) + some room for line numbers and column signs
      options = {
        number = false, -- Disable number column
        relativenumber = false,
        colorcolumn = "0", -- Disable column ruler
      },
    },
    plugins = {
      twilight = { enabled = false }, -- Don't enable Twilight when entering zen mode
      tmux = { enabled = true }, -- Disable Tmux status line when entering zen mode
      options = {
        laststatus = 0, -- turn off the statusline in zen mode
      },
    },
  },
}
