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
      function() vim.cmd("TodoTelescope layout_strategy=vertical keywords=NOW") end,
      desc = "[F]ind: [T]odo-comments (personal)",
    },
    {
      "<leader>fT",
      function() vim.cmd("TodoTelescope layout_strategy=vertical") end,
      desc = "[F]ind: [T]odo-comments (all)",
    },
    {
      "<leader>vt",
      function() vim.cmd("Trouble todo_personal toggle") end,
      desc = "[V]iew: [T]odo-comments (personal)",
    },
    {
      "<leader>vT",
      function() vim.cmd("Trouble todo toggle") end,
      desc = "[V]iew: [T]odo-comments (all)",
    },
  },
  opts = {
    keywords = {
      -- Update builtin keywords
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "IMPORTANT" } },
      -- Add personal keywords (must be separated to be able to search for them)
      NOW = { icon = " ", color = "info" }, -- Like TODO
    },
    -- Include hidden files when searching for todo-comments
    search = { args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" } },
  },
}
