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
    { "<leader>vt", "<cmd>Trouble todo_private toggle<CR>", desc = "[V]iew: private [T]odo-comments" },
    { "<leader>vT", "<cmd>Trouble todo toggle<CR>", desc = "[V]iew: [T]odo-comments" },
  },
  opts = {
    -- Add "_TODO" as a custom "private TODO" keyword for stuff to do right now & which should not be shared in the
    --  codebase. This is a convenient way of separating long term TODOs and the ones for the current task at hand.
    keywords = { _TODO = { icon = " ", color = "info" } },
    -- Include hidden files when searching for todo-comments
    search = { args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" } },
  },
}
