return {
  "chentoast/marks.nvim",
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    { "m", function() require("marks").set() end, desc = "Set mark" },
    { "mm", function() require("marks").set_next() end, desc = "Set next available mark" },
    { "dm", function() require("marks").delete() end, desc = "Delete mark" },
    { "dmm", function() require("marks").delete_line() end, desc = "Delete line marks" },
    { "<leader>xm", function() require("marks").delete_buf() end, desc = "Delete: [M]arks" },
    {
      "<leader>vm",
      function()
        require("marks").mark_state:buffer_to_list()
        vim.cmd("Trouble loclist")
      end,
      desc = "[V]iew: [M]arks",
    },
    {
      "<leader>vM",
      function()
        require("marks").mark_state:all_to_list()
        vim.cmd("Trouble loclist")
      end,
      desc = "[V]iew: [M]arks (workspace)",
    },
  },
  opts = {
    default_mappings = false,
  },
}
