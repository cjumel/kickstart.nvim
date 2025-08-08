-- Hydra.nvim
--
-- This is the Neovim implementation of the famous Emacs Hydra package, to create custom submodes and menus.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<leader>c", desc = "[C]onflict menu" },
    { "<leader>h", desc = "[H]unk menu", mode = { "n", "v" } },
    { "<leader>n", desc = "[N]avigate menu" },
    { "<leader>,", desc = "Window menu" },
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
          { ",", function() require("git-conflict").find_next("ours") end },
          { ";", function() require("git-conflict").find_prev("ours") end },
          { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
        },
        hint = [[
                              Conflict   
   _b_ ➜ Choose [B]oth   _o_ ➜ Choose [O]urs    _,_ ➜ Next conflict   
   _n_ ➜ Choose [N]one   _t_ ➜ Choose [T]eirs   _;_ ➜ Previous conflict   
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
            "t",
            function()
              vim.g.gitsigns_all_hunk_navigation = not vim.g.gitsigns_all_hunk_navigation
              if vim.g.gitsigns_all_hunk_navigation then
                vim.notify("All hunk navigation enabled", vim.log.levels.INFO)
              else
                vim.notify("All hunk navigation disabled", vim.log.levels.INFO)
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
          {
            ",",
            function()
              require("gitsigns").nav_hunk(
                ---@diagnostic disable-next-line: param-type-mismatch
                "next",
                { target = vim.g.gitsigns_all_hunk_navigation and "all" or nil }
              )
            end,
          },
          {
            ";",
            function()
              require("gitsigns").nav_hunk(
                ---@diagnostic disable-next-line: param-type-mismatch
                "prev",
                { target = vim.g.gitsigns_all_hunk_navigation and "all" or nil }
              )
            end,
          },
          { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
        },
        hint = [[
                                             Hunk
   _p_ ➜ [P]review hunk                  _t_ ➜ [T]oggle all hunk navigation   _,_ ➜ Next hunk   
   _s_ ➜ Toggle [S]tage hunk/selection   _x_ ➜ Discard hunk/selection         _;_ ➜ Previous hunk   
     
]],
      },
      {
        body = "<leader>n",
        config = {
          desc = "[N]avigate menu",
          color = "pink", -- Allow other keymaps while the Hydra is open; for some reason, this doesn't work well otherwise
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
        body = "<leader>,",
        config = { desc = "Window menu" },
        heads = {
          { "d", "<cmd>vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis<CR>" },
          { "h", "<C-w>h" },
          { "j", "<C-w>j" },
          { "k", "<C-w>k" },
          { "l", "<C-w>l" },
          { "n", "<cmd>tab new<CR>", { exit = true } },
          { "o", "<C-w>o" },
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
   _d_ ➜ Buffer [D]iff   _o_ ➜ Quit [O]ther windows        _x_ ➜ Swap window with next   
   _h_ ➜ Window left     _q_ ➜ [Q]uit window               _!_ ➜ Increase height   
   _j_ ➜ Winndow down    _s_ ➜ [S]plit window              _-_ ➜ Decrease height   
   _k_ ➜ Window up       _t_ ➜ Break window into [T]ab     _(_ ➜ Decrease width   
   _l_ ➜ Window right    _v_ ➜ Split window [V]ertically   _)_ ➜ Increase width   
   _n_ ➜ [N]ew tab       _w_ ➜ S[W]itch windows            _=_ ➜ Equalize hight/width   
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
