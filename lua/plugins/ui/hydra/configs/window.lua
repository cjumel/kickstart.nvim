return {
  key = { "<leader>,", desc = "Window menu" },
  opts = {
    body = "<leader>,",
    config = { desc = "Window menu" },
    heads = {
      { "h", "<C-w>h" },
      { "j", "<C-w>j" },
      { "k", "<C-w>k" },
      { "l", "<C-w>l" },
      { "n", function() Snacks.notifier.show_history() end, { exit = true } },
      { "o", "<C-w>o" },
      { "p", vim.diagnostic.open_float },
      { "q", "<C-w>q" },
      { "s", "<C-w>s" },
      { "t", "<C-w>T" },
      { "v", "<C-w>v" },
      { "w", "<C-w>w" },
      { "x", "<C-w>x" },
      { "z", function() Snacks.zen() end, { exit = true } },
      { "!", "<C-w>+" }, -- Mnemonic: opposite shape of "-"
      { "-", "<C-w>-" },
      { "(", "<C-w><" },
      { ")", "<C-w>>" },
      { "=", "<C-w>=" },
      { "<Esc>", nil, { exit = true, desc = false } },
    },
    hint = [[
                                      Window   
   _h_ ➜ Go left                 _q_ ➜ [Q]uit               _z_ ➜ [Z]en mode
   _j_ ➜ Go down                 _s_ ➜ [S]plit              _!_ ➜ Increase height   
   _k_ ➜ Go up                   _t_ ➜ Break into [T]ab     _-_ ➜ Decrease height   
   _l_ ➜ Go right                _v_ ➜ Split [V]ertically   _(_ ➜ Decrease width   
   _n_ ➜ [N]otifications         _w_ ➜ S[W]itch             _)_ ➜ Increase width   
   _o_ ➜ Quit [O]thers           _x_ ➜ Swap with next       _=_ ➜ Equalize hight/width   
   _p_ ➜ [P]review diagnostics
]],
  },
}
