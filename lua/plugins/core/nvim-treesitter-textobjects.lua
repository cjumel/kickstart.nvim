-- nvim-treesitter-textobjects
--
-- Syntax aware text-objects, select, move, swap, and peek support. This plugin completes the nvim-treesitter plugin
-- with the amazing feature of language-aware text-objects operations. Text-object keymaps are defined in the nvim-
-- treesitter plugin configuration.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true, -- Dependency of nvim-treesitter
  config = function()
    local repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
    vim.keymap.set(
      { "n", "x", "o" },
      ",",
      repeatable_move.repeat_last_move_next,
      { desc = 'Repeat last move in "next" direction' }
    )
    vim.keymap.set(
      { "n", "x", "o" },
      ";",
      repeatable_move.repeat_last_move_previous,
      { desc = 'Repeat last move in "previous" direction' }
    )
  end,
}
