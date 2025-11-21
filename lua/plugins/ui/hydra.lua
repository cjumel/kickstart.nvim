return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<leader>c", desc = "[C]onflict menu" },
    { "<leader>h", desc = "[H]unk menu", mode = { "n", "v" } },
    { "<leader>n", desc = "[N]avigate menu" },
    { "<leader>w", desc = "[W]indow menu" },
  },
  opts = {
    invoke_on_body = true,
    configs = {
      {
        body = "<leader>c",
        config = {
          desc = "[C]onflict menu",
          color = "pink", -- Allow other keymaps while the Hydra is open (e.g. undo)
        },
        heads = {
          { "b", function() require("git-conflict").choose("both") end },
          { "n", function() require("git-conflict").choose("none") end },
          { "o", function() require("git-conflict").choose("ours") end },
          { "t", function() require("git-conflict").choose("theirs") end },
          { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
        },
        hint = [[
                                      Conflict   
   _b_ ➜ Choose [B]oth   _n_ ➜ Choose [N]one   _o_ ➜ Choose [O]urs   _t_ ➜ Choose [T]eirs   
]],
      },
      {
        body = "<leader>h",
        config = {
          desc = "[H]unk menu",
          color = "pink", -- Allow other keymaps while the Hydra is open (e.g. move cursor and select lines to stage)
        },
        mode = { "n", "v" },
        heads = {
          -- Don't use Neovim arrow keys ("h", "j", "k", "l") or visual mode keys ("v" & "V") to be able to select lines and
          -- stage or discard them
          { "p", function() require("gitsigns").preview_hunk() end },
          {
            "s",
            function()
              if vim.fn.mode() == "n" then
                require("gitsigns").stage_hunk()
              else
                require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end
            end,
          },
          {
            "x",
            function()
              if vim.fn.mode() == "n" then
                require("gitsigns").reset_hunk()
              else
                require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end
            end,
          },
          { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
        },
        hint = [[
                                          Hunk
   _p_ ➜ [P]review hunk   _s_ ➜ Toggle [S]tage hunk/selection   _x_ ➜ Discard hunk/selection   
]],
      },
      {
        body = "<leader>n",
        config = {
          desc = "[N]avigate menu",
          color = "pink", -- Allow other keymaps while the Hydra is open, for some reason, this doesn't work well otherwise
        },
        heads = {
          { "h", "<cmd>Treewalker Left<CR>" },
          { "H", "<cmd>Treewalker SwapLeft<CR>" },
          { "j", "<cmd>Treewalker Down<CR>" },
          { "J", "<cmd>Treewalker SwapDown<CR>" },
          { "k", "<cmd>Treewalker Up<CR>" },
          { "K", "<cmd>Treewalker SwapUp<CR>" },
          { "l", "<cmd>Treewalker Right<CR>" },
          { "L", "<cmd>Treewalker SwapRight<CR>" },
          { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
        },
        hint = [[
                      Navigate   
   _h_ ➜ Left        _J_ ➜ Swap down   _l_ ➜ Right   
   _H_ ➜ Swap left   _k_ ➜ Up          _L_ ➜ Swap right   
   _j_ ➜ Down        _K_ ➜ Swap up   
]],
      },
      {
        body = "<leader>w",
        config = { desc = "[W]indow menu" },
        heads = {
          { "h", "<C-w>h" },
          { "H", "<C-w>H" },
          { "j", "<C-w>j" },
          { "J", "<C-w>J" },
          { "k", "<C-w>k" },
          { "K", "<C-w>K" },
          { "l", "<C-w>l" },
          { "L", "<C-w>L" },
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
        hint = [[
                                                            Window
    _h_ ➜ Go to the left window        _K_ ➜ Move window to far top    _s_ ➜ Split a window             _+_ ➜ Increase height   
    _H_ ➜ Move window to far left      _l_ ➜ Go to the right window    _T_ ➜ Break out into a new tab   _-_ ➜ Decrease height   
    _j_ ➜ Go to the down window        _L_ ➜ Move window to far right  _v_ ➜ Split window vertically    _<_ ➜ Decrease width   
    _J_ ➜ Move window to far bottom    _o_ ➜ Close all other windows   _w_ ➜ Switch windows             _=_ ➜ Equally high and wide   
    _k_ ➜ Go to the up window          _q_ ➜ Quit a window             _x_ ➜ Swap current with next     _>_ ➜ Increase width   
]],
      },
    },
  },
  config = function(_, opts)
    local Hydra = require("hydra")
    Hydra.setup(opts)
    for _, config in ipairs(opts.configs) do
      Hydra(config)
    end
  end,
}
