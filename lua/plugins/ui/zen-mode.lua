-- Zen Mode
--
-- Zen mode provides a distraction-free mode for Neovim. It's a very nice and simple addition to Neovim, integrated
-- with many plugins and other tools, like Tmux, and I like to use it to focus on one buffer edition.

return {
  "folke/zen-mode.nvim",
  keys = { { "<leader>z", function() require("zen-mode").toggle() end, desc = "[Z]en mode" } },
  opts = {
    window = {
      backdrop = 1, -- No difference between the background and the window
      width = 126, -- Base width (120) + some room for line numbers and column signs
      options = { number = false, relativenumber = false }, -- Disable line numbering
    },
    plugins = {
      options = { laststatus = 0 }, -- Turn off the statusline in zen mode
      tmux = { enabled = true }, -- Disable Tmux status line when entering zen mode
    },
  },
}
