return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", mode = { "n", "t" }, desc = "Window left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<CR>", mode = { "n", "t" }, desc = "Window down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<CR>", mode = { "n", "t" }, desc = "Window up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<CR>", mode = { "n", "t" }, desc = "Window right" },
  },
}
