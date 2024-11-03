-- Todo Comments
--
-- Todo Comments is a plugin to highlight, list and search todo-comments (`TODO`, `HACK`, `BUG`, etc.), in your
-- projects. It is very convenient to document directly in the code base the next steps to do, long-term issues left for
-- the future like unresolved bugs or performance issues, etc. Besides, it is very nicely integrated with other plugins,
-- like telescope.nvim, Trouble, or even code snippets.

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>ft",
      -- Filter with default keywords + "TODO_" - "NOTE" - "INFO"
      "<cmd>TodoTelescope layout_strategy=vertical keywords=FIX,FIXME,BUG,FIXIT,ISSUE,TODO,TODO_,HACK,WARN,WARNING,"
        .. "XXX,PERF,OPTIM,PERFORMANCE,OPTIMIZE,TEST,TESTING,PASSED,FAILED<CR>",
      desc = "[F]ind: [T]odo comments",
    },
    {
      "<leader>fn",
      "<cmd>TodoTelescope layout_strategy=vertical keywords=TODO_<CR>", -- Filter with "TODO_" only
      desc = "[F]ind: todo-[N]ow comments",
    },
    { "<leader>vt", "<cmd>Trouble todo toggle<CR>", desc = "[V]iew: [T]odo comments" },
    { "<leader>vn", "<cmd>Trouble todo_now toggle<CR>", desc = "[V]iew: todo-[N]ow comments" },
  },
  opts = {
    -- Add "TODO_" as a custom keyword for stuff to do right now & which should not be shared in the codebase. I find
    --  this a convenient way of separating long term TODOs and the ones for the current task at hand.
    keywords = { ["TODO_"] = { icon = " ", color = "info" } },
    -- Include hidden files when searching for todo-comments
    search = { args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" } },
  },
}
