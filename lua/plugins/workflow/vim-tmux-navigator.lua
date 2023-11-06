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
      desc = "Window left",
    },
    {
      "<C-l>",
      "<cmd> TmuxNavigateRight <CR>",
      desc = "Window right",
    },
    {
      "<C-j>",
      "<cmd> TmuxNavigateDown <CR>",
      desc = "Window down",
    },
    {
      "<C-k>",
      "<cmd> TmuxNavigateUp <CR>",
      desc = "Window up",
    },
  },
}
