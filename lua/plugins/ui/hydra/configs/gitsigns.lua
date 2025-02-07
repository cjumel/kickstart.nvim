return {
  key = { "<leader>h", mode = { "n", "v" }, desc = "[H]unk Hydra" },
  opts = {
    body = "<leader>h",
    config = {
      desc = "[H]unk Hydra",
      color = "pink", -- Enable other keymaps while the Hydra is open
      -- Setting `buffer=true` or `buffer=bufnr` makes the hunk manager keymaps only work in a single buffer, while still
      -- being able to switch buffer. In that case, the Hydra is still opened but the keymaps don't work in the new
      -- buffer, which is quite confusing, so I prefer to use `buffer=nil`.
      buffer = nil,
    },
    mode = { "n", "v" },
    -- Let's keep "h", "j", "k", "l", "w", "e", and "b" for navigation, "v" for visual mode, "a", "i" and "g" for text
    -- objects in visual mode, to still be able to use them while the Hydra is open
    hint = [[
                                       Hunk Hydra   
   _p_ ➜ [P]review hunk                  _x_ ➜ Discard hunk/selection   _;_ ➜ Previous hunk   
   _s_ ➜ Toggle [S]tage hunk/selection   _,_ ➜ Next hunk   
]],
    heads = {
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
      -- "," & ";" are not made repeatable on purpose, to be able to resume the previous next/previous moves later
      { ",", function() require("gitsigns").nav_hunk("next", { target = "all" }) end },
      { ";", function() require("gitsigns").nav_hunk("prev", { target = "all" }) end },
      { "q", nil, { exit = true, mode = "n", desc = false } },
      { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
    },
  },
}
