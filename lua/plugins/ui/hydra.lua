-- Hydra.nvim
--
-- Neovim implementation of the famous Emacs Hydra package.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<C-w>", desc = "Window manager" },
  },
  opts = {
    invoke_on_body = true,
    hint = {
      float_opts = {
        border = "rounded", -- Improve visibility with transparent background
      },
    },
  },
  config = function(_, opts)
    local Hydra = require("hydra")

    Hydra.setup(opts)

    -- Window manager
    -- This Hydra uses the builtin prefix (body) and keymaps (heads), as describded by WhichKey
    Hydra({
      body = "<C-w>",
      config = {
        desc = "Window manager",
      },
      hint = [[
   _+_ ➜ Increase height         _h_ ➜ Go to the left window    _q_ ➜ [Q]uit window                   
   _-_ ➜ Decrease height         _j_ ➜ Go to the down window    _s_ ➜ [S]plit window                  
   _>_ ➜ Increase width          _k_ ➜ Go to the up window      _v_ ➜ [V]ertically split window       
   _<_ ➜ Decrease width          _l_ ➜ Go to the right window   _w_ ➜ Switch windows                  
   _=_ ➜ Equally high and wide   _o_ ➜ Close [O]ther windows    _x_ ➜ Swap current window with next   
]],
      heads = {
        { "+", "<C-w>+" },
        { "-", "<C-w>-" },
        { "<", "<C-w><" },
        { "=", "<C-w>=" },
        { ">", "<C-w>>" },
        -- { "_", "<C-w>_" }, -- Not supported by Hydra hint, but not important
        -- { "|", "<C-w>|" }, -- Not important as well, and disabled by consistency with "_"
        { "h", "<C-w>h" },
        { "j", "<C-w>j" },
        { "k", "<C-w>k" },
        { "l", "<C-w>l" },
        { "o", "<C-w>o" },
        { "q", "<C-w>q" },
        { "s", "<C-w>s" },
        -- { "T", "<C-w>T" }, -- I don't use tabs so it's not useful
        { "v", "<C-w>v" },
        { "w", "<C-w>w" },
        { "x", "<C-w>x" },
        { "<Esc>", nil, { exit = true, desc = false } },
      },
    })
  end,
}
