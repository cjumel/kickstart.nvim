local hint = [[
                                          Window   
   _h_ ➜ Decrease [H]eight         _v_ ➜ Split window [V]ertically   _<C-h>_ ➜ Window left   
   _H_ ➜ Increase [H]eight         _w_ ➜ Decrease [W]idth            _<C-j>_ ➜ Window down   
   _o_ ➜ Close [O]ther windows     _W_ ➜ Increase [W]idth            _<C-k>_ ➜ Window up   
   _q_ ➜ [Q]uit window             _x_ ➜ Swap window with next       _<C-l>_ ➜ Window left   
   _s_ ➜ [S]plit window            _=_ ➜ Equally high and wide       _<C-w>_ ➜ Switch windows   
   _t_ ➜ Break window into [T]ab   
]]
return {
  key = { "<C-w>", desc = "Window menu" },
  opts = {
    body = "<C-w>",
    config = {
      desc = "Window menu",
    },
    hint = hint,
    heads = {
      { "h", "<C-w>-" },
      { "H", "<C-w>+" },
      { "o", "<C-w>o" },
      { "q", "<C-w>q" },
      { "s", "<C-w>s" },
      { "t", "<C-w>T" },
      { "v", "<C-w>v" },
      { "w", "<C-w><" },
      { "W", "<C-w>>" },
      { "x", "<C-w>x" },
      { "=", "<C-w>=" },
      { "<C-h>", "<C-w>h" },
      { "<C-j>", "<C-w>j" },
      { "<C-k>", "<C-w>k" },
      { "<C-l>", "<C-w>l" },
      { "<C-w>", "<C-w>w" },
      { "<Esc>", nil, { exit = true, desc = false } },
    },
  },
}
