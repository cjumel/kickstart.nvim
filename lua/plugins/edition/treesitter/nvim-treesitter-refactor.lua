-- nvim-treesitter-refactor
--
-- Refactor module for nvim-treesitter.

return {
  "nvim-treesitter/nvim-treesitter-refactor",
  lazy = true,
  config = function()
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_reference, prev_reference = ts_repeat_move.make_repeatable_move_pair(
      require("nvim-treesitter-refactor.navigation").goto_next_usage,
      require("nvim-treesitter-refactor.navigation").goto_previous_usage
    )
    vim.keymap.set({ "n", "x", "o" }, "[r", next_reference, { desc = "Next reference" })
    vim.keymap.set({ "n", "x", "o" }, "]r", prev_reference, { desc = "Previous reference" })
  end,
}
