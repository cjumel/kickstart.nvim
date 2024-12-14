-- Todo Comments
--
-- Todo Comments is a plugin to highlight, list and search todo-comments (`TODO`, `HACK`, `BUG`, etc.), in your
-- projects. It is very convenient to document directly in the code base the next steps to do, long-term issues left for
-- the future like unresolved bugs, performance issues, or simply important notes for the readers. Besides, it is very
-- nicely integrated with other plugins, like telescope.nvim, Trouble, making it super useful.

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>ft",
      function() vim.cmd("TodoTelescope layout_strategy=vertical") end,
      desc = "[F]ind: [T]odo-comments",
    },
    {
      "<leader>fn",
      function() vim.cmd("TodoTelescope layout_strategy=vertical keywords=NOW") end,
      desc = "[F]ind: [N]ow todo-comments",
    },
    { "<leader>vt", function() vim.cmd("Trouble todo toggle") end, desc = "[V]iew: [T]odo-comments" },
    { "<leader>vn", function() vim.cmd("Trouble todo_now toggle") end, desc = "[V]iew: [N]ow todo-comments" },
  },
  opts = {
    -- Add more keyword and keyword alternatives
    keywords = {
      TODO = { icon = " ", color = "info", alt = { "NOW" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "IMPORTANT" } },
    },
    -- Include hidden files when searching for todo-comments
    search = { args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" } },
  },
}
