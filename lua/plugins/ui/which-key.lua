-- Which Key
--
-- Which Key is a plugin which helps creating keybindings that stick. It displays a popup with possible key bindings of
-- the command you started typing. It is, for me, essential to use and learn both builtin Neovim and custom key
-- bindings.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    operators = { -- Add operators that will trigger motion and text object completion
      -- substitute.nvim
      ge = "Exchange",
      go = "Overwrite",
      gp = "Paste over",
      gs = "Substitute",
      -- nvim-surround
      ys = "Surround",
      yS = "Surround on new lines",
    },
    window = { border = "rounded" }, -- Improve visibility with transparent background
  },
  config = function(_, opts)
    local which_key = require("which-key")

    which_key.setup(opts)

    -- Document existing key chains
    local _ = "which_key_ignore"
    which_key.register({
      ["["] = { name = "Next", _ = _ },
      ["]"] = { name = "Previous", _ = _ },
      ["gr"] = { name = "LSP", _ = _ },

      ["<leader>"] = { name = "Leader", _ = _ },
      ["<leader>c"] = { name = "[C]opilot", _ = _ },
      ["<leader>d"] = { name = "[D]AP", _ = _ },
      ["<leader>f"] = { name = "[F]ind", mode = { "n", "v" }, _ = _ },
      ["<leader>g"] = { name = "[G]it", mode = { "n", "v" }, _ = _ },
      ["<leader>o"] = { name = "[O]verseer", _ = _ },
      ["<leader>t"] = { name = "[T]erm", mode = { "n", "v" }, _ = _ },
      ["<leader>v"] = { name = "[V]iew", mode = { "n", "v" }, _ = _ },
      ["<leader>x"] = { name = "Trouble", _ = _ },
      ["<leader>y"] = { name = "[Y]ank", mode = { "n", "v" }, _ = _ },
    })
  end,
}
