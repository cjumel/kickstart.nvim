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
              vim.list_extend(keyword_filters, { "_TODO" })
            end
            if opts.todo then ---@diagnostic disable-line: undefined-field
              vim.list_extend(keyword_filters, {
                "_TODO",
                "TODO",
                "FIXME",
                "BUG",
                "FIX",
                "FIXIT",
                "ISSUE",
                "PERF",
                "OPTIM",
                "PERFORMANCE",
                "OPTIMIZE",
                "TEST",
                "TESTING",
                "PASSED",
                "FAILED",
              })
            end
            if opts.note then ---@diagnostic disable-line: undefined-field
              vim.list_extend(keyword_filters, {
                "NOTE",
                "HACK",
                "WARN",
                "WARNING",
                "XXX",
                "INFO",
                "IMPORTANT",
              })
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
    {
      "<leader>vt",
      function() vim.cmd("Trouble todo title='{hl:Title}Todo-comments {hl} {count}'") end,
      desc = "[V]iew: [T]odo-comments",
    },
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
  config = function(_, opts)
    local todo_comments = require("todo-comments")
    todo_comments.setup(opts)

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_todo_comment, prev_todo_comment =
      ts_repeat_move.make_repeatable_move_pair(todo_comments.jump_next, todo_comments.jump_prev)
    vim.keymap.set({ "n", "x", "o" }, "]t", next_todo_comment, { desc = "Next todo-comment" })
    vim.keymap.set({ "n", "x", "o" }, "[t", prev_todo_comment, { desc = "Previous todo-comment" })
  end,
}
