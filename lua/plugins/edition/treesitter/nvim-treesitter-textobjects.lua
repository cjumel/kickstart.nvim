-- nvim-treesitter-textobject
--
-- Syntax aware text-objects, select, move, swap, and peek support.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  keys = {
    {
      ",",
      require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_next,
      mode = { "n", "x", "o" },
      desc = "Repeat last move next",
    },
    {
      ";",
      require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_previous,
      mode = { "n", "x", "o" },
      desc = "Repeat last move previous",
    },
  },
}
