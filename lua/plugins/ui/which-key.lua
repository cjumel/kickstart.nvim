-- Which Key
--
-- Show the available keymaps once you start writink a few keys, the marks and registers.

-- TODO:
-- - make which-key groups not appear if they are empty (relevant for dap, lsp & trouble)

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    window = {
      border = "rounded", -- Adding a border is lot better for transparent background
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)

    -- document existing key chains
    require("which-key").register({
      ["<leader>,"] = { name = "Settings", _ = "which_key_ignore" },
      ["<leader>?"] = { name = "Help", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]ebug", _ = "which_key_ignore" },
      ["<leader>dp"] = { name = "[D]ebug [P]ython", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
      ["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
      ["<leader>n"] = { name = "[N]oice", _ = "which_key_ignore" },
      ["<leader>o"] = { name = "[O]verseer", _ = "which_key_ignore" },
      ["<leader>x"] = { name = "Trouble", _ = "which_key_ignore" },
    })
  end,
}
