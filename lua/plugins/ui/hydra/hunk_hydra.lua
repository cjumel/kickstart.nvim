-- The hunk Hydra provides a simple menu to interact with Git hunks (e.g. navigate between them, stage, discard or
-- unstage them, etc.) using gitsigns.nvim, without having to press repeatedly a keymap prefix ("<leader>h" in my case)
-- to perform several actions.

local Hydra = require("hydra")

Hydra({
  body = "<leader>h",
  config = {
    desc = "[H]unk Hydra",
    color = "pink", -- For synchron buffer actions
    -- Setting `buffer=true` or `buffer=bufnr` makes the hunk manager keymaps only work in a single buffer, while still
    --  being able to switch buffer (as `foreign_keys="run"` can't be overriden for pink Hydra). In that case, the Hydra
    --  is still opened but the keymaps don't work in the new buffer, which is quite confusing, so I prefer not to use
    --  this.
    buffer = nil,
  },
  mode = { "n", "v" },
  hint = [[
                                    Hunk Hydra
   _K_ ➜ Hover hunk               _u_ ➜ [U]nstage staged hunk    _,_ ➜ Next hunk    
   _s_ ➜ [S]tage hunk/selection   _x_ ➜ Discard hunk/selection   _;_ ➜ Previous hunk    
]],
  heads = {
    -- In the following, let's not use keys which could be used for buffer navigation (like "h", "j", "k", "l") or
    --  text selection ("v", or any key involved in a text object), that way we can use them to navigate between hunks
    --  and select part of them, before staging, discarding, etc. while remaining in the Hydra.

    { "K", function() require("gitsigns").preview_hunk() end },
    {
      -- "a" (like in `git add`) doesn't work well in visual mode, there is a delay due to text-objects keymaps
      --  starting with `a`, so let's avoid using it
      "s",
      function()
        if vim.fn.mode() == "n" then
          require("gitsigns").stage_hunk()
        else
          require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end
      end,
    },
    { "u", function() require("gitsigns").undo_stage_hunk() end },
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
    -- "," & ";" are not repeatable on purpose, to be able to resume the previous next/previous keymaps after leaving
    --  the Hydra
    { ",", function() require("gitsigns").next_hunk({ navigation_message = false }) end },
    { ";", function() require("gitsigns").prev_hunk({ navigation_message = false }) end },

    -- Exit heads
    { "q", nil, { exit = true, mode = "n", desc = false } },
    { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
  },
})
