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
        local todo_comment_keywords = require("config.todo-comment-keywords")
        Snacks.picker("todo_comments", {
          title = "Todo-comments",
          keywords = todo_comment_keywords.todo_all,
          hidden = true,
          layout = { preset = "telescope_vertical" },
        })
      end,
      desc = "[F]ind: [T]odo-comments",
    },
    {
      "<leader>fn",
      function()
        local todo_comment_keywords = require("config.todo-comment-keywords")
        Snacks.picker("todo_comments", {
          title = "Note-comments",
          keywords = todo_comment_keywords.note_all,
          hidden = true,
          layout = { preset = "telescope_vertical" },
        })
      end,
      desc = "[F]ind: [N]ote-comments",
    },
    {
      "<leader>fp",
      function()
        local todo_comment_keywords = require("config.todo-comment-keywords")
        Snacks.picker("todo_comments", {
          title = "Private Todo-comments",
          keywords = todo_comment_keywords.todo_private,
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
  opts = {
    keywords = {
      -- Update builtin keywords
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "IMPORTANT" } },
      -- Add personal keywords (must be separated to be able to search for them)
      _TODO = { icon = " ", color = "info" }, -- Like TODO
    },
    search = {
      pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]], -- Support todo-comments with author
      -- Include hidden files (useful for trouble.nvim integration)
      args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" },
    },
    highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] }, -- Support todo-comments with author
  },
}
