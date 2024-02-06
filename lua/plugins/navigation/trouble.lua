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
      {
        "<leader>xd",
        function()
          require("trouble").toggle("document_diagnostics")
        end,
        desc = "Trouble: [D]iagnostics",
        ft = "*",
      },
      -- Next/prev Trouble items need to be lazy keys to be available directly in a buffer when
      -- Trouble is lazy-loaded with the buffer already opened
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
  config = function(_, opts)
    require("trouble").setup(opts)

    -- The following keymap require Trouble to be used already so no need to put it in lazy keys
    -- Defining this keymap here avoids having it shown alone when no buffer is opened and Trouble
    -- is not loaded
    vim.keymap.set("n", "<leader>xx", require("trouble").toggle, { desc = "Trouble: toggle" })
  end,
}
