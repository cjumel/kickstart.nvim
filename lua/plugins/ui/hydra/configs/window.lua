local hint = [[
                                           Window   
   _h_ ➜ Go to the left window    _l_ ➜ Go to the right window   _t_ ➜ Break window into [T]ab   
   _H_ ➜ Decrease width           _L_ ➜ Increase width           _v_ ➜ Split window [V]ertically
   _j_ ➜ Go to the down window    _o_ ➜ Close [O]ther windows    _w_ ➜ Switch windows   
   _J_ ➜ Decrease height          _q_ ➜ [Q]uit window            _x_ ➜ Swap window with next
   _k_ ➜ Go to the up window      _s_ ➜ [S]plit window           _=_ ➜ Equally high and wide   
   _K_ ➜ Increase height          
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
      { "h", "<C-w>h" },
      { "H", "<C-w><" },
      { "j", "<C-w>j" },
      { "J", "<C-w>-" },
      { "k", "<C-w>k" },
      { "K", "<C-w>+" },
      { "l", "<C-w>l" },
      { "L", "<C-w>>" },
      { "o", "<C-w>o" },
      { "q", "<C-w>q" },
      { "s", "<C-w>s" },
      { "t", "<C-w>T" },
      { "v", "<C-w>v" },
      { "w", "<C-w>w" },
      { "x", "<C-w>x" },
      { "=", "<C-w>=" },
      { "<Esc>", nil, { exit = true, desc = false } },
    },
  },
}
