-- vim-tmux-navigator
--
-- Enable to use control + h/j/k/l seamlessly to navigate between neovim windows and tmux panes
-- when running neovim within tmux.

return {
  "christoomey/vim-tmux-navigator",
  keys = {
    {
      "<C-h>",
      "<cmd> TmuxNavigateLeft <CR>",
      mode = { "n", "t" },
      desc = "Window left",
    },
    {
      "<C-l>",
      "<cmd> TmuxNavigateRight <CR>",
      mode = { "n", "t" },
      desc = "Window right",
    },
    {
      "<C-j>",
      "<cmd> TmuxNavigateDown <CR>",
      mode = { "n", "t" },
      desc = "Window down",
    },
    {
      "<C-k>",
      "<cmd> TmuxNavigateUp <CR>",
      mode = { "n", "t" },
      desc = "Window up",
    },
  },
}
