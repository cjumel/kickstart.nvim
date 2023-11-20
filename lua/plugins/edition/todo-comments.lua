-- todo-comments
--
-- Enable highlighting for todo, fixme, bug, fixit, issue & note comments.
-- This plugin can also be used as a provider for trouble.nvim.

return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    sign_priority = 1, -- Low sign priority to not override other signs
    search = {
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--hidden",
        "--glob=!.git/",
      },
    },
  },
  config = function(_, opts)
    require("todo-comments").setup(opts)

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local tdc = require("todo-comments")
    -- make sure forward function comes first
    local next_todo_comment_repeat, prev_todo_comment_repeat =
      ts_repeat_move.make_repeatable_move_pair(tdc.jump_next, tdc.jump_prev)
    vim.keymap.set(
      { "n", "x", "o" },
      "[t",
      next_todo_comment_repeat,
      { desc = "Next todo comment" }
    )
    vim.keymap.set(
      { "n", "x", "o" },
      "]t",
      prev_todo_comment_repeat,
      { desc = "Previous todo comment" }
    )
  end,
}
