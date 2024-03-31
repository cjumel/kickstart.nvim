-- nvim-treesitter-textobjects
--
-- Syntax aware text-objects, select, move, swap, and peek support.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    local repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")

    local utils = require("utils")
    local mmap = utils.keymap.mmap

    mmap(",", repeatable_move.repeat_last_move_next, "Repeat last move next")
    mmap(";", repeatable_move.repeat_last_move_previous, "Repeat last move previous")
  end,
}
