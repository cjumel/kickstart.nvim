local hint = [[
                                          Window   
   _h_ ➜ Increase [H]eight         _v_ ➜ Split window [V]ertically   _<C-h>_ ➜ Window left   
   _H_ ➜ Decrease [H]eight         _w_ ➜ Increase [W]idth            _<C-j>_ ➜ Window down   
   _o_ ➜ Close [O]ther windows     _W_ ➜ Decrease [W]idth            _<C-k>_ ➜ Window up   
   _q_ ➜ [Q]uit window             _x_ ➜ Swap window with next       _<C-l>_ ➜ Window left   
   _s_ ➜ [S]plit window            _=_ ➜ Equally high and wide       _<C-w>_ ➜ Switch windows   
   _t_ ➜ Break window into [T]ab   
]]

return {
  key = { "<leader>,", desc = "Window menu" },
  opts = {
    body = "<leader>,",
    config = {
      desc = "Window menu",
    },
    hint = hint,
    heads = {
      { "h", "<C-w>+" },
      { "H", "<C-w>-" },
      { "o", "<C-w>o" },
      { "q", "<C-w>q" },
      { "s", "<C-w>s" },
      { "t", "<C-w>T" },
      { "v", "<C-w>v" },
      { "w", "<C-w>>" },
      { "W", "<C-w><" },
      { "x", "<C-w>x" },
      { "=", "<C-w>=" },
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>" },
      { "<C-w>", "<C-w>w" },
      { "<Esc>", nil, { exit = true, desc = false } },
    },
  },
}
