-- Trouble
--
-- Trouble provides a pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code is causing.

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
local next_trouble_item, previous_trouble_item = ts_repeat_move.make_repeatable_move_pair(function()
  require("trouble").next({ skip_groups = true, jump = true })
end, function()
  require("trouble").previous({ skip_groups = true, jump = true })
end)

return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "folke/todo-comments.nvim",
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("trouble").toggle()
      end,
      desc = "[T]rouble: [T]oggle",
    },
    {
      "<leader>td",
      function()
        require("trouble").toggle("document_diagnostics")
      end,
      desc = "[T]rouble: [D]iagnostics (document)",
    },
    {
      "<leader>tD",
      function()
        require("trouble").toggle("workspace_diagnostics")
      end,
      desc = "[T]rouble: [D]iagnostics (workspace)",
    },
    {
      "<leader>tl",
      function()
        require("todo-comments") -- Lazy load todo-comments which adds a "todo" source to trouble
        require("trouble").toggle("todo")
      end,
      desc = "[T]rouble: todo [L]ist",
    },
    {
      "[t",
      next_trouble_item,
      desc = "Next Trouble item",
    },
    {
      "]t",
      previous_trouble_item,
      desc = "Previous Trouble item",
    },
  },
}
