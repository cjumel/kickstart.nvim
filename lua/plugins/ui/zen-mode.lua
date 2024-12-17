-- zen-mode.nvim
--
-- zen-mode.nvim provides a full feature distraction-free mode for Neovim. It's a very nice and simple addition to
-- Neovim, integrated with many plugins and other tools, like Tmux. It makes possible to remove a lot of distraction
-- from the screen, while also centering the current buffer in the window. Besides, it is more robust and feature-rich
-- than alternatives like snacks.nvim corresponding feature.

return {
  "folke/zen-mode.nvim",
  keys = { { "<leader>z", function() require("zen-mode").toggle() end, desc = "[Z]en mode" } },
  opts = {
    window = {
      width = 130, -- To support buffers with up until 120 line length and the number/sign columns
      options = { number = false, relativenumber = false, signcolumn = "yes" },
    },
    plugins = {
      options = { laststatus = 0 }, -- Disable Neovim statusline
      tmux = { enabled = true }, -- Disable Tmux statusline
    },
  },
}
