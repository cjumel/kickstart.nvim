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
  lazy = true,
  init = function()
    vim.keymap.set("n", "<leader>to", function()
      require("trouble").open()
    end, { desc = "[T]rouble: [O]pen" })

    -- Diagnostics
    vim.keymap.set("n", "<leader>dl", function()
      require("trouble").open("document_diagnostics")
    end, { desc = "[D]iagnostics: [L]ist in buffer" })
    vim.keymap.set("n", "<leader>dL", function()
      require("trouble").open("workspace_diagnostics")
    end, { desc = "[D]iagnostics: [L]ist in workspace" })

    -- Todo-comments
    vim.keymap.set("n", "<leader>tl", function()
      require("trouble").open("todo")
    end, { desc = "[T]odo: [L]ist" })
  end,
  opts = {},
}
