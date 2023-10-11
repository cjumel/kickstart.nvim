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
      "<leader>to",
      function()
        require("trouble").open()
      end,
      desc = "[T]rouble [O]pen",
    },

    -- Diagnostics
    {
      "<leader>dd",
      function()
        require("trouble").open("document_diagnostics")
      end,
      desc = "[D]iagnostics: in [D]ocument",
    },
    {
      "<leader>dw",
      function()
        require("trouble").open("workspace_diagnostics")
      end,
      desc = "[D]iagnostics: in [W]orkspace",
    },

    -- Todo-comments
    {
      "<leader>tl",
      function()
        require("trouble").open("todo")
      end,
      desc = "[T]odo [L]ist",
    },
  },
  opts = {
    action_keys = {
      jump = { "<cr>", "=" }, -- jump to the diagnostic or open / close folds
    },
  },
}
