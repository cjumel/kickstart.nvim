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
      { "o", "<C-w>o" },
      { "p", vim.diagnostic.open_float },
      { "q", "<C-w>q" },
      { "s", "<C-w>s" },
      { "t", "<C-w>T" },
      { "v", "<C-w>v" },
      { "w", "<C-w>w" },
      { "x", "<C-w>x" },
      { "!", "<C-w>+" }, -- Mnemonic: opposite shape of "-"
      { "-", "<C-w>-" },
      { "(", "<C-w><" },
      { ")", "<C-w>>" },
      { "=", "<C-w>=" },
      { "<Esc>", nil, { exit = true, desc = false } },
    },
    hint = [[
                                   Window   
   _h_ ➜ Go left                 _q_ ➜ [Q]uit               _!_ ➜ Increase height   
   _j_ ➜ Go down                 _s_ ➜ [S]plit              _-_ ➜ Decrease height   
   _k_ ➜ Go up                   _t_ ➜ Break into [T]ab     _(_ ➜ Decrease width   
   _l_ ➜ Go right                _v_ ➜ Split [V]ertically   _)_ ➜ Increase width   
   _o_ ➜ Quit [O]thers           _w_ ➜ S[W]itch             _=_ ➜ Equalize hight/width   
   _p_ ➜ [P]review diagnostics   _x_ ➜ Swap with next   
]],
  },
}
