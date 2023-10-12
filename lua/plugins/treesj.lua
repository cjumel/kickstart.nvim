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
      "gS",
      function()
        require("treesj").split()
      end,
      desc = "[S]plit current node",
    },
    {
      "gJ",
      function()
        require("treesj").join()
      end,
      desc = "[J]oin current node",
    },
    {
      "gT",
      function()
        require("treesj").toggle()
      end,
      desc = "[T]oggle split/join current node",
    },
  },
  opts = {
    use_default_keymaps = false,
    max_join_length = 100,
  },
}
