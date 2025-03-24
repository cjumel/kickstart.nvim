return {
  key = { "<leader>n", desc = "[N]avigate menu" },
  opts = {
    body = "<leader>n",
    config = { desc = "[N]avigate menu" },
    heads = {
      { "h", "<cmd>Treewalker Left<CR>" },
      { "H", "<cmd>Treewalker SwapLeft<CR>" },
      { "j", "<cmd>Treewalker Down<CR>" },
      { "J", "<cmd>Treewalker SwapDown<CR>" },
      { "k", "<cmd>Treewalker Up<CR>" },
      { "K", "<cmd>Treewalker SwapUp<CR>" },
      { "l", "<cmd>Treewalker Right<CR>" },
      { "L", "<cmd>Treewalker SwapRight<CR>" },
      { "q", nil, { exit = true, mode = "n", desc = false } },
      { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
    },
    hint = [[
                      Navigate   
   _h_ ➜ Left        _J_ ➜ Swap down   _l_ ➜ Right   
   _H_ ➜ Swap left   _k_ ➜ Up          _L_ ➜ Swap right   
   _j_ ➜ Down        _K_ ➜ Swap up   
]],
  },
}
