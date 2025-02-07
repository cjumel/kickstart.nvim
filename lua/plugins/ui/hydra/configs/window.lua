return {
  key = { "<C-w>", desc = "Window Hydra" },
  opts = {
    body = "<C-w>",
    config = {
      desc = "Window Hydra",
    },
    -- A few keymaps are not re-implemented:
    --  - "d"/"<C-d>" to show the diagnostics under the cursor, as I have re-implemented it with a custom keymap
    --  - "_" to max out the height, as not supported by Hydra
    --  - "|" to max out the width, by consistency with "_"
    hint = [[
                                        Window Hydra   
   _h_ ➜ Go to the left window    _s_ ➜ [S]plit window              _+_ ➜ Increase height   
   _j_ ➜ Go to the down window    _T_ ➜ Break window into [T]ab     _-_ ➜ Decrease height   
   _k_ ➜ Go to the up window      _v_ ➜ Split window [V]ertically   _<_ ➜ Decrease width   
   _l_ ➜ Go to the right window   _w_ ➜ Switch windows              _=_ ➜ Equally high and wide   
   _o_ ➜ Close [O]ther windows    _x_ ➜ Swap window with next       _>_ ➜ Increase width   
   _q_ ➜ [Q]uit window   
]],
    heads = {
      { "h", "<C-w>h" },
      { "j", "<C-w>j" },
      { "k", "<C-w>k" },
      { "l", "<C-w>l" },
      { "o", "<C-w>o" },
      { "q", "<C-w>q" },
      { "s", "<C-w>s" },
      { "T", "<C-w>T" },
      { "v", "<C-w>v" },
      { "w", "<C-w>w" },
      { "x", "<C-w>x" },
      { "+", "<C-w>+" },
      { "-", "<C-w>-" },
      { "<", "<C-w><" },
      { "=", "<C-w>=" },
      { ">", "<C-w>>" },
      { "<Esc>", nil, { exit = true, desc = false } },
    },
  },
}
