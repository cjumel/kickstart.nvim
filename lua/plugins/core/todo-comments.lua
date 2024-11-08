-- Todo Comments
--
-- Todo Comments is a plugin to highlight, list and search todo-comments (`TODO`, `HACK`, `BUG`, etc.), in your
-- projects. It is very convenient to document directly in the code base the next steps to do, long-term issues left for
-- the future like unresolved bugs, performance issues, or simply important notes for the readers. Besides, it is very
-- nicely integrated with other plugins, like telescope.nvim, Trouble, making it super useful.

local tdc_keywords = require("plugins.core.todo-comments.keywords")

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufNewFile", "BufReadPre" },
  keys = function()
    local actions = require("plugins.core.todo-comments.actions")
    return {
      { "<leader>fp", actions.find_personal_todos, desc = "[F]ind: [P]ersonal todo-comments" },
      { "<leader>ft", actions.find_todos, desc = "[F]ind: [T]odo todo-comments" },
      { "<leader>fn", actions.find_notes, desc = "[F]ind: [N]ote todo-comments" },
      { "<leader>vp", actions.view_personal_todos, desc = "[V]iew: [P]ersonal todo-comments" },
      { "<leader>vt", actions.view_todos, desc = "[V]iew: [T]odo todo-comments" },
      { "<leader>vn", actions.view_notes, desc = "[V]iew: [N]ote todo-comments" },
    }
  end,
  opts = {
    -- Add a personal todo keyword, for stuff to do right now & which should not be shared in the codebase. I find this
    -- a convenient way of separating long term TODOs and the ones for the current task at hand, especially to search
    -- them automatically.
    keywords = { [tdc_keywords.personal_todo] = { icon = " ", color = "info" } },
    -- Include hidden files when searching for todo-comments
    search = { args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--hidden" } },
  },
}
