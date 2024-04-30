-- Trouble
--
-- Trouble provides pretty lists for showing diagnostics, references, telescope results, quickfix and location lists
-- to help you solve all the trouble your code is causing. It is a very nice interface for very various stuff, quite
-- complementary with Telescope.

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = function()
    local trouble = require("trouble")
    local toggle = trouble.toggle
    return {
      { "<leader>xx", function() toggle() end, desc = "Trouble: toggle" },
      { "<leader>xd", function() toggle("document_diagnostics") end, desc = "Trouble: [D]ocument diagnostics" },
      { "<leader>xw", function() toggle("workspace_diagnostics") end, desc = "Trouble: [W]orkspace diagnostics" },
      { "<leader>xq", function() toggle("quickfix") end, desc = "Trouble: [Q]uickfix" },
      { "<leader>xl", function() toggle("loclist") end, desc = "Trouble: [L]oclist" },
    }
  end,
  opts = {},
  config = function(_, opts)
    local trouble = require("trouble")
    local utils = require("utils")

    trouble.setup(opts)

    utils.keymap.set_move_pair({ "[x", "]x" }, {
      function() trouble.next({ skip_groups = true, jump = true }) end,
      function() trouble.previous({ skip_groups = true, jump = true }) end,
    }, { { desc = "Next Trouble item" }, { desc = "Previous Trouble item" } })
  end,
}
