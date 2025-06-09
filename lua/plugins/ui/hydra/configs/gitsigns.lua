return {
  key = { "<leader>h", mode = { "n", "v" }, desc = "[H]unk menu" },
  opts = {
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
      { ",", function() require("gitsigns").nav_hunk("next") end },
      { ";", function() require("gitsigns").nav_hunk("prev") end },
      { "?", function() require("gitsigns").nav_hunk("next", { target = "all" }) end },
      { ".", function() require("gitsigns").nav_hunk("prev", { target = "all" }) end },
      { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
    },
    hint = [[
                                               Hunk   
   _p_ ➜ [P]review hunk                  _,_ ➜ Next hunk       _?_ ➜ Next hunk (including staged)
   _s_ ➜ Toggle [S]tage hunk/selection   _;_ ➜ Previous hunk   _._ ➜ Previous hunk (including staged)   
   _x_ ➜ Discard hunk/selection   
]],
  },
}
