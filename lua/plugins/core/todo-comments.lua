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
          hidden = true,
          layout = { preset = "telescope_vertical" },
          toggles = {
            private = "p",
            todo = "t",
            note = "n",
          },
          transform = function(item, ctx)
            local opts = ctx.picker.opts or {}
            local keyword_filters = {}
            if opts.private then ---@diagnostic disable-line: undefined-field
              vim.list_extend(keyword_filters, todo_comment_keywords.todo_private)
            end
            if opts.todo then ---@diagnostic disable-line: undefined-field
              vim.list_extend(keyword_filters, todo_comment_keywords.todo_all)
            end
            if opts.note then ---@diagnostic disable-line: undefined-field
              vim.list_extend(keyword_filters, todo_comment_keywords.note_all)
            end
            if vim.tbl_isempty(keyword_filters) then
              return true
            end
            for _, keyword in ipairs(keyword_filters) do
              if item.text:find(keyword, 1, true) then
                return true
              end
            end
            return false
          end,
          actions = {
            toggle_private_custom = function(picker)
              local opts = picker.opts or {}
              opts.private = not opts.private ---@diagnostic disable-line: inject-field
              opts.todo = false ---@diagnostic disable-line: inject-field
              opts.note = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_todo_custom = function(picker)
              local opts = picker.opts or {}
              opts.private = false ---@diagnostic disable-line: inject-field
              opts.todo = not opts.todo ---@diagnostic disable-line: inject-field
              opts.note = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
            toggle_note_custom = function(picker)
              local opts = picker.opts or {}
              opts.private = false ---@diagnostic disable-line: inject-field
              opts.todo = false ---@diagnostic disable-line: inject-field
              opts.note = not opts.note ---@diagnostic disable-line: inject-field
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<M-p>"] = { "toggle_private_custom", mode = "i" },
                ["<M-t>"] = { "toggle_todo_custom", mode = "i" },
                ["<M-n>"] = { "toggle_note_custom", mode = "i" },
              },
            },
          },
        })
      end,
      desc = "[F]ind: [T]odo-comments",
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
