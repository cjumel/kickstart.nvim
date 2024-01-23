-- Trouble
--
-- Trouble provides a pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code is causing.

-- ISSUE:
-- - When closing a window with Trouble opened, Neovim will crash, see:
-- https://github.com/folke/trouble.nvim/issues/253
-- - When closing a buffer with Trouble opened, NeoVim will crash, see:
-- https://github.com/folke/trouble.nvim/issues/134

return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = function()
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_trouble_item, previous_trouble_item = ts_repeat_move.make_repeatable_move_pair(
      function()
        require("trouble").next({ skip_groups = true, jump = true })
      end,
      function()
        require("trouble").previous({ skip_groups = true, jump = true })
      end
    )

    return {
      { -- Should be available outside of buffers for uses with Telescope's output for instance
        "<leader>xx",
        function()
          require("trouble").toggle()
        end,
        desc = "Trouble: toggle",
      },
      {
        "<leader>xd",
        function()
          require("trouble").toggle("document_diagnostics")
        end,
        desc = "Trouble: [D]iagnostics",
        ft = "*",
      },
      -- Next/prev Trouble items need to be lazy keys to be available directly in a buffer when
      -- Trouble is lazy-loaded with the buffer already opened; besides, they do not need to be
      -- available outside of buffers, as in this case the focus should be on Trouble's window
      {
        "[x",
        next_trouble_item,
        desc = "Next Trouble item",
        ft = "*",
      },
      {
        "]x",
        previous_trouble_item,
        desc = "Previous Trouble item",
        ft = "*",
      },
    }
  end,
  opts = {},
}
