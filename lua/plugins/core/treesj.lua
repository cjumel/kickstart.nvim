-- TreeSJ
--
-- TreeSJ is a small plugin for easily splitting/joining blocks of code like lists, dictionnaries, arrays, etc. using
-- Treesitter. Since it uses Treesitter, it handles many cases better than the buitlin `J` command, for instance, but
-- on the other hand, it doesn't work when Treesitter is not available, or on comment blocks for instance.

return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = { { "S", function() require("treesj").toggle() end, desc = "Split/join node" } }, -- Like "J" (join lines)
  opts = {
    use_default_keymaps = false,
    max_join_length = 200, -- Set a high limit to be able to join over regular line-length limits, but not too high
  },
}
