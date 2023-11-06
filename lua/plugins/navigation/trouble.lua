-- Trouble
--
-- Trouble provides a pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code is causing.

return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
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
  },
  opts = {},
}
