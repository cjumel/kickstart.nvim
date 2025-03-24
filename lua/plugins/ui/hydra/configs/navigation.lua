return {
  key = { "<leader>n", desc = "[N]avigation menu" },
  opts = {
    body = "<leader>n",
    config = { desc = "[N]avigation menu" },
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
                     Navigation   
   _h_ ➜ Go left     _J_ ➜ Swap down    _l_ ➜ Go right   
   _H_ ➜ Swap left   _k_ ➜ Go up        _L_ ➜ Swap right   
   _j_ ➜ Go down     _K_ ➜ Swap up   
]],
  },
}
