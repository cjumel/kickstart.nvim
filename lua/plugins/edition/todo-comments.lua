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
  keys = {
    {
      "<leader>xt",
      function()
        -- Todo-comments adds a "todo" source to trouble
        require("trouble").toggle("todo")
      end,
      desc = "Trouble: [T]odo list",
    },
  },
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
  config = function(_, opts)
    local tdc = require("todo-comments")
    tdc.setup(opts)

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_todo_comment, prev_todo_comment =
      ts_repeat_move.make_repeatable_move_pair(tdc.jump_next, tdc.jump_prev)
    vim.keymap.set({ "n", "x", "o" }, "[t", next_todo_comment, { desc = "Next todo comment" })
    vim.keymap.set({ "n", "x", "o" }, "]t", prev_todo_comment, { desc = "Previous todo comment" })
  end,
}
