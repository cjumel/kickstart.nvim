return {
  key = { "<leader>,", desc = "Window menu" },
  opts = {
    body = "<leader>,",
    config = { desc = "Window menu" },
    heads = {
      { "d", "<cmd>vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis<CR>" },
      { "h", "<C-w>h" },
      { "j", "<C-w>j" },
      { "k", "<C-w>k" },
      { "l", "<C-w>l" },
      { "n", function() Snacks.notifier.show_history() end, { exit = true } },
      { "o", "<C-w>o" },
      { "q", "<C-w>q" },
      { "r", vim.diagnostic.reset, { exit = true } },
      { "s", "<C-w>s" },
      { "t", "<C-w>T" },
      { "v", "<C-w>v" },
      { "w", "<C-w>w" },
      { "x", "<C-w>x" },
      { "z", function() Snacks.zen.zen() end, { exit = true } },
      { "!", "<C-w>+" }, -- Mnemonic: opposite shape of "-"
      { "-", "<C-w>-" },
      { "(", "<C-w><" },
      { ")", "<C-w>>" },
      { "=", "<C-w>=" },
      { "<Esc>", nil, { exit = true, desc = false } },
    },
    hint = [[
                                          Window
   _d_ ➜ Buffer [D]iff            _q_ ➜ [Q]uit window               _z_ ➜ [Z]en mode   
   _h_ ➜ Window left              _r_ ➜ [R]eset diagnostics         _!_ ➜ Increase height   
   _j_ ➜ Winndow down             _s_ ➜ [S]plit window              _-_ ➜ Decrease height   
   _k_ ➜ Window up                _t_ ➜ Break window into [T]ab     _(_ ➜ Decrease width   
   _l_ ➜ Window right             _v_ ➜ Split window [V]ertically   _)_ ➜ Increase width   
   _n_ ➜ [N]otification history   _w_ ➜ S[W]itch windows            _=_ ➜ Equalize hight/width   
   _o_ ➜ Quit [O]ther windows     _x_ ➜ Swap window with next       
]],
  },
}
