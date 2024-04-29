-- Which Key
--
-- Show the available keymaps once you start writink a few keys, the marks and registers.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    operators = { -- Add non-native operators that will trigger motion and text object completion
      -- Comment.nvim
      gb = "Comment toggle blockwise",
      gc = "Comment toggle linewise",
      -- substitute.nvim
      go = "Overwrite",
      gO = "Overwrite in range",
      gs = "Substitute",
      ge = "Exchange",
      -- nvim-surround
      ys = "Surround",
      yS = "Surround on new lines",
    },
    window = {
      border = "rounded", -- Improve visibility with transparent background
    },
  },
  config = function(_, opts)
    local which_key = require("which-key")

    which_key.setup(opts)

    -- document existing key chains
    local _ = "which_key_ignore"
    which_key.register({
      ["["] = { name = "Next", _ = _ },
      ["]"] = { name = "Previous", _ = _ },

      ["<leader>"] = { name = "Leader", _ = _ },
      ["<leader>?"] = { name = "Help", _ = _ },
      ["<leader>a"] = { name = "[A]ctions", _ = _ },
      ["<leader>d"] = { name = "[D]AP", _ = _ },
      ["<leader>f"] = { name = "[F]ind", mode = { "n", "v" }, _ = _ },
      ["<leader>g"] = { name = "[G]it", mode = { "n", "v" }, _ = _ },
      ["<leader>l"] = { name = "[L]SP", _ = _ },
      ["<leader>m"] = { name = "[M]arks", _ = _ },
      ["<leader>o"] = { name = "[O]verseer", _ = _ },
      ["<leader>t"] = { name = "[T]erm", mode = { "n", "v" }, _ = _ },
      ["<leader>v"] = { name = "[V]iew", mode = { "n", "v" }, _ = _ },
      ["<leader>x"] = { name = "Trouble", _ = _ },
      ["<leader>y"] = { name = "[Y]ank", mode = { "n", "v" }, _ = _ },
    })
  end,
}
