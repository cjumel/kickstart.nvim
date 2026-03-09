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
          show_empty = true, -- Some stuff can appear after using toggles
          layout = { preset = "telescope_vertical" },
          dirs = vim.bo.filetype == "oil" and { require("oil").get_current_dir() } or nil,
          directory = vim.bo.filetype == "oil",
          directory_path = vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
          todo = true,
          toggles = {
            directory = "d",
            todo = "t",
          },
          transform = function(item, ctx)
            local opts = ctx.picker.opts or {}
            if opts.todo then ---@diagnostic disable-line: undefined-field
              local keyword_filters = {
                "BUG",
                "FIX",
                "FIXIT",
                "FIXME",
                "ISSUE",
                "TODO",
              }
              for _, keyword in ipairs(keyword_filters) do
                if item.text:find(keyword, 1, true) then
                  return true
                end
              end
              return false
            end
            return true
          end,
          actions = {
            toggle_directory_ = function(picker)
              local opts = picker.opts or {}
              opts.directory = not opts.directory ---@diagnostic disable-line: inject-field
              opts.dirs = opts.directory and { opts.directory_path } or nil ---@diagnostic disable-line: undefined-field, inject-field
              picker:find()
            end,
            toggle_todo_ = function(picker)
              local opts = picker.opts or {}
              opts.private = false ---@diagnostic disable-line: inject-field
              opts.todo = not opts.todo ---@diagnostic disable-line: inject-field
              opts.note = false ---@diagnostic disable-line: inject-field
              picker:find()
            end,
          },
          win = {
            input = {
              keys = {
                ["<M-d>"] = { "toggle_directory_", mode = { "n", "i" } },
                ["<M-t>"] = { "toggle_todo_", mode = { "n", "i" } },
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
    },
    search = {
      pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]], -- Support todo-comments with author
      -- Include hidden files (useful for trouble.nvim integration)
      args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" },
    },
    highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] }, -- Support todo-comments with author
  },
}
