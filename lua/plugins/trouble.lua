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
      "<leader>dl",
      function()
        require("trouble").open("document_diagnostics")
      end,
      desc = "[D]iagnostics: [L]ist in buffer",
    },
    {
      "<leader>dL",
      function()
        require("trouble").open("workspace_diagnostics")
      end,
      desc = "[D]iagnostics: [L]ist in workspace",
    },

    -- Todo-comments
    {
      "<leader>td",
      function()
        require("trouble").open("todo")
      end,
      desc = "[T]o-[D]o list",
    },
  },
  opts = {},
}
