-- Zen Mode
--
-- Zen mode provides a centered mode striped out of distractions. It's a very nice addition to Neovim, especially
-- since it works over window splits (useful to center one split) and with Tmux.

return {
  "folke/zen-mode.nvim",
  keys = { { "<leader>z", function() require("zen-mode").toggle() end, desc = "[Z]en mode" } },
  opts = {
    window = {
      backdrop = 1, -- No difference between the background and the window
      width = 126, -- Base width (120) + some room for line numbers and column signs
      options = { number = false, relativenumber = false, colorcolumn = "0" }, -- Disable numbers and ruler column
    },
    plugins = {
      twilight = { enabled = false }, -- Don't enable Twilight when entering zen mode
      tmux = { enabled = true }, -- Disable Tmux status line when entering zen mode
      options = { laststatus = 0 }, -- Turn off the statusline in zen mode
    },
  },
}
