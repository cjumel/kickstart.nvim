-- Which Key
--
-- Show the available keymaps once you start writink a few keys, the marks and registers.

return {
  "folke/which-key.nvim",
  cmd = { "WhichKey" },
  keys = { "<leader>", "<c-r>", '"', "'", "`", "d", "c", "y", "v", "g", "[", "]" },
  config = function()
    require("which-key").setup({})

    -- document existing key chains
    require("which-key").register({
      ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]iagnostics/[D]ebug", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
      ["<leader>gc"] = { name = "[G]it [C]ommit", _ = "which_key_ignore" },
      ["<leader>h"] = { name = "[H]arpoon", _ = "which_key_ignore" },
      ["<leader>l"] = { name = "[L]ight theme", _ = "which_key_ignore" },
      ["<leader>q"] = { name = "[Q]uick", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "[S]tand", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]odo/[T]rouble", _ = "which_key_ignore" },
    })
  end,
}
