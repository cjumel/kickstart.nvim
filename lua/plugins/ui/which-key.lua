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
    require("which-key").register({
      ["["] = { name = "Next", _ = "which_key_ignore" },
      ["]"] = { name = "Previous", _ = "which_key_ignore" },

      ["<leader>"] = { name = "Leader", _ = "which_key_ignore" },
      ["<leader>?"] = { name = "Help", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]AP", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
      ["<leader>fa"] = { name = "[F]ind (w. all files/dirs)", _ = "which_key_ignore" },
      ["<leader>fh"] = { name = "[F]ind (w. hidden files/dirs)", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
      ["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
      ["<leader>n"] = { name = "[N]oice", _ = "which_key_ignore" },
      ["<leader>o"] = { name = "[O]verseer", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]oggleTerm", _ = "which_key_ignore", mode = { "n", "v" } },
      ["<leader>x"] = { name = "Trouble", _ = "which_key_ignore" },
    })
  end,
}
