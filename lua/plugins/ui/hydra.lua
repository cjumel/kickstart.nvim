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
      config = {
        desc = "Window manager",
      },
      hint = [[
   _+_ ➜ Increase height         _h_ ➜ Go to the left window     _q_ ➜ Quit a window             
   _-_ ➜ Decrease height         _j_ ➜ Go to the down window     _s_ ➜ Split window              
   _<_ ➜ Decrease width          _k_ ➜ Go to the up window       _v_ ➜ Split window vertically   
   _=_ ➜ Equally high and wide   _l_ ➜ Go to the right window    _w_ ➜ Switch windows            
   _>_ ➜ Increase width          _o_ ➜ Close all other windows   _x_ ➜ Swap current with nex     
]],
      body = "<C-w>",
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
