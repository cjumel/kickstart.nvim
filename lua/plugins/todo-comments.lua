-- todo-comments
--
-- Enable highlighting for TODO, FIXME, BUG, FIXIT, ISSUE & NOTE comments.
-- This plugin can also be used as a provider for trouble.nvim.

return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  lazy = false,
  config = function()
    require("todo-comments").setup({
      sign_priority = 1,
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        -- NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      merge_keywords = false, -- when true, custom keywords will be merged with the defaults
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
    })

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
