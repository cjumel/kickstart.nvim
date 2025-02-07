return {
  key = { "<leader>x", desc = "Conflict Hydra" },
  opts = {
    body = "<leader>x",
    config = {
      desc = "Conflict Hydra",
      color = "pink", -- Enable other keymaps while the Hydra is open
    },
    hint = [[
                           Conflict Hydra   
   _b_ ➜ Choose [B]oth   _o_ ➜ Choose [O]urs    _,_ ➜ Next conflict   
   _n_ ➜ Choose [N]one   _t_ ➜ Choose [T]eirs   _;_ ➜ Previous conflict   
]],
    heads = {
      { "b", function() require("git-conflict").choose("both") end },
      { "n", function() require("git-conflict").choose("none") end },
      { "o", function() require("git-conflict").choose("ours") end },
      { "t", function() require("git-conflict").choose("theirs") end },
      { ",", function() require("git-conflict").find_next("ours") end },
      { ";", function() require("git-conflict").find_prev("ours") end },

      -- Exit heads
      { "q", nil, { exit = true, mode = "n", desc = false } },
      { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
    },
  },
}
