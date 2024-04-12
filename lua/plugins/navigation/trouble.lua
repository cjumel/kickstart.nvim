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
      function() require("trouble").toggle() end,
      desc = "Trouble: toggle",
    },
    {
      "<leader>xd",
      function() require("trouble").toggle("document_diagnostics") end,
      desc = "Trouble: [D]ocument diagnostics",
    },
    {
      "<leader>xw",
      function() require("trouble").toggle("workspace_diagnostics") end,
      desc = "Trouble: [W]orkspace diagnostics",
    },
    {
      "<leader>xq",
      function() require("trouble").toggle("quickfix") end,
      desc = "Trouble: [Q]uickfix",
    },
    {
      "<leader>xl",
      function() require("trouble").toggle("loclist") end,
      desc = "Trouble: [L]oclist",
    },
  },
  opts = {
    mode = "document_diagnostics", -- Default mode for toggle
  },
  config = function(_, opts)
    local trouble = require("trouble")

    trouble.setup(opts)

    local utils = require("utils")

    utils.keymap.set_move_pair({ "[x", "]x" }, {
      function() require("trouble").next({ skip_groups = true, jump = true }) end,
      function() require("trouble").previous({ skip_groups = true, jump = true }) end,
    }, { { desc = "Next Trouble item" }, { desc = "Previous Trouble item" } })
  end,
}
