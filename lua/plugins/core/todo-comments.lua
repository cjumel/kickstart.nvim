-- todo-comments.nvim
--
-- Highlight, list and search todo comments in your projects

return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>ft",
      function()
        Snacks.picker("todo_comments", {
          title = "Todo-comments",
          keywords = vim.g.todo_comment_keywords_todo or {},
          hidden = true,
          layout = { preset = "telescope_vertical" },
        })
      end,
      desc = "[F]ind: [T]odo-comments",
    },
    {
      "<leader>fn",
      function()
        Snacks.picker("todo_comments", {
          title = "Note-comments",
          keywords = vim.g.todo_comment_keywords_note or {},
          hidden = true,
          layout = { preset = "telescope_vertical" },
        })
      end,
      desc = "[F]ind: [N]ote-comments",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker("todo_comments", {
          title = "Private Todo-comments",
          keywords = vim.g.todo_comment_keywords_private or {},
          hidden = true,
          layout = { preset = "telescope_vertical" },
        })
      end,
      desc = "[F]ind: [P]rivate todo-comments",
    },
    { "<leader>vt", function() vim.cmd("Trouble todo") end, desc = "[V]iew: [T]odo-comments" },
    { "<leader>vn", function() vim.cmd("Trouble todo_note") end, desc = "[V]iew: [N]ote-comments" },
    { "<leader>vp", function() vim.cmd("Trouble todo_private") end, desc = "[V]iew: [P]rivate todo-comments" },
  },
  init = function()
    vim.g.todo_comment_keywords_todo = {
      "FIX",
      "FIXME",
      "BUG",
      "FIXIT",
      "ISSUE",
      "TODO",
      "PERF",
      "OPTIM",
      "PERFORMANCE",
      "OPTIMIZE",
      "TEST",
      "TESTING",
      "PASSED",
      "FAILED",
    }
    vim.g.todo_comment_keywords_note = {
      "HACK",
      "WARN",
      "WARNING",
      "XXX",
      "NOTE",
      "INFO",
      "IMPORTANT",
    }
    vim.g.todo_comment_keywords_private = {
      "_TODO",
    }
  end,
  opts = {
    keywords = {
      -- Update builtin keywords
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "IMPORTANT" } },
      -- Add personal keywords (must be separated to be able to search for them)
      _TODO = { icon = " ", color = "info" }, -- Like TODO
    },
    -- Include hidden files when searching for todo-comments when using trouble.nvim
    search = { args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" } },
  },
}
