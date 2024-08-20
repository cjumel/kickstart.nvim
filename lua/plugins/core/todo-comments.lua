-- Todo Comments
--
-- Todo Comments is a plugin to highlight, list and search todo-comments (`TODO`, `HACK`, `BUG`, etc.), in your
-- projects. It is very convenient to document directly in the code base the next steps to do, long-term issues left for
-- the future like unresolved bugs or performance issues, etc. Besides, it is very nicely integrated with other plugins,
-- like Telescope, Trouble, or code snippets, to define custom todo-comment snippets.

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    { "<leader>xt", "<cmd>Trouble todo_private toggle<CR>", desc = "Trouble: private [T]odo-comments" },
    { "<leader>xT", "<cmd>Trouble todo toggle<CR>", desc = "Trouble: [T]odo-comments" },
  },
  opts = {
    -- Add "_TODO" as a custom "private TODO" keyword for stuff to do right now & which should not be shared in the
    --  codebase. This is a convenient way of separating long term TODOs and the ones for the current task at hand.
    keywords = { _TODO = { icon = " ", color = "info" } },
    -- Include hidden files when searching for todo-comments
    search = { args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" } },
  },
  config = function(_, opts)
    local tdc = require("todo-comments")
    local utils = require("utils")

    tdc.setup(opts)

    utils.keymap.set_move_pair({ "[t", "]t" }, {
      tdc.jump_next,
      tdc.jump_prev,
    }, { { desc = "Next todo-comment" }, { desc = "Previous todo-comment" } })
  end,
}
