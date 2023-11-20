-- Trouble
--
-- Trouble provides a pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code is causing.

return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- The following dependencies are needed but don't need to be loaded when the plugin is loaded
    -- "folke/todo-comments.nvim",
  },
  keys = {
    {
      "<leader>xx",
      function()
        require("trouble").toggle()
      end,
      desc = "Trouble: toggle Trouble",
    },
    {
      "<leader>xq",
      function()
        require("trouble").toggle("quickfix")
      end,
      desc = "Trouble: toggle [Q]uickfix",
    },
    {
      "<leader>xl",
      function()
        require("trouble").toggle("loclist")
      end,
      desc = "Trouble: toggle [L]oclist",
    },
    {
      "<leader>xd",
      function()
        require("trouble").toggle("document_diagnostics")
      end,
      desc = "Trouble: [D]ocument diagnostics",
    },
    {
      "<leader>xw",
      function()
        require("trouble").toggle("workspace_diagnostics")
      end,
      desc = "Trouble: [W]orkspace diagnostics",
    },
    {
      "<leader>xt",
      function()
        require("todo-comments") -- Lazy load todo-comments which adds a "todo" source to trouble
        require("trouble").toggle("todo")
      end,
      desc = "Trouble: [T]odo-list",
    },
    {
      "[x",
      function()
        vim.cmd("TroubleNext")
      end,
      desc = "Next Trouble item",
    },
    {
      "]x",
      function()
        vim.cmd("TroublePrevious")
      end,
      desc = "Previous Trouble item",
    },
  },
  config = function()
    require("trouble").setup()

    local next_trouble_item = function()
      require("trouble").next({ skip_groups = true, jump = true })
    end
    local previous_trouble_item = function()
      require("trouble").previous({ skip_groups = true, jump = true })
    end

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_trouble_item_repeat, previous_trouble_item_repeat =
      ts_repeat_move.make_repeatable_move_pair(next_trouble_item, previous_trouble_item)

    vim.api.nvim_create_user_command(
      "TroubleNext",
      next_trouble_item_repeat,
      { desc = "Next Trouble item" }
    )
    vim.api.nvim_create_user_command(
      "TroublePrevious",
      previous_trouble_item_repeat,
      { desc = "Previous Trouble item" }
    )
  end,
}
