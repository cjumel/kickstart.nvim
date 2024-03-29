-- Which Key
--
-- Show the available keymaps once you start writink a few keys, the marks and registers.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    operators = { -- Add non-native operators that will trigger motion and text object completion
      gc = "Comments",
      ys = "Surround",
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
      ["<leader>d"] = { name = "[D]AP", _ = _ },
      ["<leader>f"] = { name = "[F]ind", mode = { "n", "v" }, _ = _ },
      ["<leader>g"] = { name = "[G]it", mode = { "n", "v" }, _ = _ },
      ["<leader>l"] = { name = "[L]SP", _ = _ },
      ["<leader>m"] = { name = "[M]arks", _ = _ },
      ["<leader>n"] = { name = "[N]oice", _ = _ },
      ["<leader>o"] = { name = "[O]verseer", _ = _ },
      ["<leader>t"] = { name = "[T]erm", mode = { "n", "v" }, _ = _ },
      ["<leader>x"] = { name = "Trouble", _ = _ },
    })
  end,
}
