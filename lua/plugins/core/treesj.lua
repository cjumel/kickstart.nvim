return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = { { "S", function() require("treesj").toggle() end, desc = "Split/join node" } }, -- Like "J" (join lines)
  opts = {
    use_default_keymaps = false, -- Don't enable default keymaps
    max_join_length = 200, -- Set a high limit to be able to join over regular line-length limits, but not too much
  },
}
