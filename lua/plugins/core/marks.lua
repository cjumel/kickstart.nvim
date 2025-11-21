return {
  "chentoast/marks.nvim",
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    { "m", function() require("marks").set() end, desc = "Set mark" },
    { "mm", function() require("marks").set_next() end, desc = "Set next available mark" },
    { "dm", function() require("marks").delete() end, desc = "Delete mark" },
    { "dmm", function() require("marks").delete_line() end, desc = "Delete line marks" },
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
  config = function(_, opts)
    local marks = require("marks")
    marks.setup(opts)

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_mark, prev_mark = ts_repeat_move.make_repeatable_move_pair(marks.next, marks.prev)
    vim.keymap.set({ "n", "x", "o" }, "]`", next_mark, { desc = "Next mark" })
    vim.keymap.set({ "n", "x", "o" }, "[`", prev_mark, { desc = "Previous mark" })
  end,
}
