-- Trouble
--
-- Trouble provides a pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code is causing.

return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim", -- Add a 'todo' source
  },
  keys = {
    {
      "<leader>xx",
      function()
        require("trouble").toggle()
      end,
      desc = "[X] Trouble: [X] toggle",
    },
    {
      "<leader>xd",
      function()
        require("trouble").toggle("document_diagnostics")
      end,
      desc = "[X] Trouble: [D]ocument diagnostics",
    },
    {
      "<leader>xw",
      function()
        require("trouble").toggle("workspace_diagnostics")
      end,
      desc = "[X] Trouble: [W]orkspace diagnostics",
    },
    {
      "<leader>tl",
      function()
        require("trouble").toggle("todo")
      end,
      desc = "[T]odo: [L]ist",
    },
  },
  opts = {
    action_keys = {
      jump = { "<cr>", "=" }, -- jump to the diagnostic or open / close folds
    },
  },
}
