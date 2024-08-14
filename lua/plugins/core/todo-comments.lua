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
    { "<leader>xn", "<cmd>Trouble todo_now toggle<CR>", desc = "Trouble: [N]OW todo-comments" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Trouble: [T]odo-comments" },
  },
  opts = {
    -- Add "NOW" as a custom keyword for stuff to do right now. This makes possible to add and and display only the
    --  todo-comments added for the current task at hand, while not being polluted by the long-term todo-comments,
    --  which may not be related to it. NOW todo-comments are designed as an alternative to TODO (with the same icon
    --  & color), but which should not be shared in any way.
    keywords = { NOW = { icon = " ", color = "info" } },
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
