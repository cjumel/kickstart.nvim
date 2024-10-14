-- The hunk Hydra provides a simple interface to interact with Git hunks using Gitsigns features.

local Hydra = require("hydra")

Hydra({
  body = "<leader>h",
  config = {
    desc = "[H]unk Hydra",
    color = "pink", -- For synchron buffer actions
    -- Setting `buffer=true` or `buffer=bufnr` makes the hunk manager keymaps only work in a single buffer, while still
    -- being able to switch buffer (as `foreign_keys="run"` can't be overriden for pink Hydra). In that case, the Hydra
    -- is still opened but the keymaps don't work in the new buffer, which is quite confusing.
    buffer = nil,
  },
  mode = { "n", "v" },
  hint = [[
   ^ ^                            ^ ^          Hunk Hydra           ^ ^                                
   _,_ ➜ Next hunk                _K_ ➜ Hover hunk                  _u_ ➜ [U]nstage last staged hunk   
   _;_ ➜ Previous hunk            _s_ ➜ [S]tage hunk/selection      _x_ ➜ Discard hunk/selection   
]],
  heads = {
    -- "," & ";" are not repeatable on purpose, to be able to resume the previous movements after leaving the Hydra
    { ",", function() require("gitsigns").next_hunk({ navigation_message = false }) end },
    { ";", function() require("gitsigns").prev_hunk({ navigation_message = false }) end },
    -- Don't use a key for preview which could be used for navigating (like "h", "j", "k", "l") or selecting ("v", or
    -- any key involved in a text object) to be able to use them to stage
    { "K", function() require("gitsigns").preview_hunk() end },
    {
      -- "a" (like in `git add`) doesn't work well in visual mode, there is a delay due to text-objects keymaps with `a`
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
    { "q", nil, { exit = true, mode = "n", desc = false } },
    { "<Esc>", nil, { exit = true, mode = "n", desc = false } },
  },
})
