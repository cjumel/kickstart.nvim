-- Trouble
--
-- Trouble provides pretty lists for showing diagnostics, references, telescope results, quickfix and location lists
-- to help you solve all the trouble your code is causing. It is a very nice interface for very various stuff, quite
-- complementary with Telescope and other plugins using the quickfix and loclist lists.

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = function()
    local trouble = require("trouble")
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    local next_trouble_item, prev_trouble_item = ts_repeat_move.make_repeatable_move_pair(
      function() trouble.next({ skip_groups = true, jump = true }) end,
      function() trouble.previous({ skip_groups = true, jump = true }) end
    )

    return {
      { "<leader>xx", trouble.toggle, desc = "Trouble: toggle" },
      { "<leader>xq", function() trouble.open("quickfix") end, desc = "Trouble: [Q]uickfix" },
      { "<leader>xl", function() trouble.open("loclist") end, desc = "Trouble: [L]oclist" },
      { "<leader>xd", function() trouble.open("document_diagnostics") end, desc = "Trouble: buffer [D]iagnostics" },
      { "<leader>xD", function() trouble.open("workspace_diagnostics") end, desc = "Trouble: all [D]iagnostics" },
      { "[x", next_trouble_item, mode = { "n", "x", "o" }, desc = "Next Trouble item" },
      { "]x", prev_trouble_item, mode = { "n", "x", "o" }, desc = "Previous Trouble item" },
    }
  end,
  opts = {},
}
