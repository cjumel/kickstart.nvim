-- TreeSJ
--
-- Neovim plugin for splitting/joining blocks of code like arrays, hashes, statements, objects, dictionaries, etc.

return {
  "Wansmer/treesj",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "S",
      function()
        require("treesj").toggle()
      end,
      desc = "Split node toggle",
      ft = "*",
    },
  },
  opts = {
    use_default_keymaps = false,
    max_join_length = 100,
  },
}
