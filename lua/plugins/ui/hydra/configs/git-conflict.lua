return {
  body = "<leader>m",
  config = {
    desc = "[M]erge conflict menu",
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
                           Merge Conflict   
   _b_ ➜ Choose [B]oth   _o_ ➜ Choose [O]urs    _,_ ➜ Next conflict   
   _n_ ➜ Choose [N]one   _t_ ➜ Choose [T]eirs   _;_ ➜ Previous conflict   
]],
}
