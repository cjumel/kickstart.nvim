-- Which Key
--
-- Show the available keymaps once you start writink a few keys, the marks and registers.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      registers = false, -- I don't use them and sometimes trigger them by mistake
    },
    operators = { -- Trigger which key when an operator is called
      gc = "Comments",
      ys = "Surround",
    },
    window = {
      border = "rounded", -- Adding a border is lot better for transparent background
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)

    -- document existing key chains
    local _ = "which_key_ignore"
    require("which-key").register({
      ["["] = { name = "Next", _ = _ },
      ["]"] = { name = "Previous", _ = _ },

      ["<leader>"] = { name = "Leader", _ = _ },
      ["<leader>?"] = { name = "Help", _ = _ },
      ["<leader>d"] = { name = "[D]AP", _ = _ },
      ["<leader>f"] = { name = "[F]ind", _ = _ },
      ["<leader>fa"] = { name = "[F]ind (w. all files/dirs)", _ = _ },
      ["<leader>fh"] = { name = "[F]ind (w. hidden files/dirs)", _ = _ },
      ["<leader>g"] = { name = "[G]it", _ = _ },
      ["<leader>l"] = { name = "[L]SP", _ = _ },
      ["<leader>n"] = { name = "[N]oice", _ = _ },
      ["<leader>o"] = { name = "[O]verseer", _ = _ },
      ["<leader>t"] = { name = "[T]oggleTerm", mode = { "n", "v" }, _ = _ },
      ["<leader>x"] = { name = "Trouble", _ = _ },
    })
  end,
}
