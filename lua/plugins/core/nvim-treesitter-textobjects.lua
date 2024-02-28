-- nvim-treesitter-textobjects
--
-- Syntax aware text-objects, select, move, swap, and peek support.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    local repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")

    vim.keymap.set(
      { "n", "x", "o" },
      ",",
      repeatable_move.repeat_last_move_next,
      { desc = "Repeat last move next" }
    )
    vim.keymap.set(
      { "n", "x", "o" },
      ";",
      repeatable_move.repeat_last_move_previous,
      { desc = "Repeat last move previous" }
    )
  end,
}
