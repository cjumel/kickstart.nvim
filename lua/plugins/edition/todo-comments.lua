-- todo-comments
--
-- Enable highlighting for todo, fixme, bug, fixit, issue & note comments.
-- This plugin can also be used as a provider for trouble.nvim.

return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = function()
    local tdc = require("todo-comments")
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_todo_comment, prev_todo_comment =
      ts_repeat_move.make_repeatable_move_pair(tdc.jump_next, tdc.jump_prev)

    return {
      {
        "<leader>ft",
        function()
          require("telescope") -- Lazy load module if necessary
          vim.cmd("TodoTelescope")
        end,
        desc = "[F]ind: [T]odo-comments",
      },
      {
        "[t",
        next_todo_comment,
        mode = { "n", "x", "o" },
        desc = "Next todo comment",
      },
      {
        "]t",
        prev_todo_comment,
        mode = { "n", "x", "o" },
        desc = "Previous todo comment",
      },
    }
  end,
  opts = {
    sign_priority = 7, -- Just above gitsigns
    keywords = {
      TODO = { icon = " ", color = "info" },
      NOTE = { icon = " ", color = "hint" },
      BUG = { icon = " ", color = "error", alt = { "FIXME", "ISSUE" } },
    },
    merge_keywords = false,
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
}
