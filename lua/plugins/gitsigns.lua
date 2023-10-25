-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua, which make it and fugitive
-- perfect for a complete git integration.

return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      -- Navigation (make them repeatable with tree-sitter-objects)
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      -- make sure forward function comes first
      local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(
        require("gitsigns").next_hunk,
        require("gitsigns").prev_hunk
      )
      local next_conflict_marker_repeat, prev_conflict_marker_repeat = ts_repeat_move.make_repeatable_move_pair(
        function()
          vim.cmd("silent!/<<<<<<< \\|=======\\|>>>>>>> ")
        end,
        function()
          vim.cmd("silent!?<<<<<<< \\|=======\\|>>>>>>> ")
        end
      )
      vim.keymap.set({ "n", "x", "o" }, "[g", next_hunk_repeat, { desc = "Next Git hunk" })
      vim.keymap.set({ "n", "x", "o" }, "]g", prev_hunk_repeat, { desc = "Previous Git hunk" })
      vim.keymap.set(
        { "n", "x", "o" },
        "[G",
        next_conflict_marker_repeat,
        { desc = "Next Git conflict marker" }
      )
      vim.keymap.set(
        { "n", "x", "o" },
        "]G",
        prev_conflict_marker_repeat,
        { desc = "Previous Git conflict marker" }
      )

      -- Actions
      vim.keymap.set(
        "n",
        "<leader>gp",
        require("gitsigns").preview_hunk,
        { buffer = bufnr, desc = "[G]it: [P]review hunk" }
      )
      vim.keymap.set(
        "n",
        "<leader>ga",
        require("gitsigns").stage_hunk,
        { buffer = bufnr, desc = "[G]it: [A]dd hunk" }
      )
      vim.keymap.set("v", "<leader>ga", function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "[G]it: [A]dd lines" })
      vim.keymap.set(
        "n",
        "<leader>gA",
        require("gitsigns").stage_buffer,
        { buffer = bufnr, desc = "[G]it: [A]dd buffer" }
      )
      vim.keymap.set(
        "n",
        "<leader>gu",
        require("gitsigns").undo_stage_hunk,
        { buffer = bufnr, desc = "[G]it: [U]ndo 'add hunk'" }
      )
      vim.keymap.set(
        "n",
        "<leader>gr",
        require("gitsigns").reset_hunk,
        { buffer = bufnr, desc = "[G]it: [R]eset hunk" }
      )
      vim.keymap.set("v", "<leader>gr", function()
        require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "[G]it: [R]eset lines" })
      vim.keymap.set(
        "n",
        "<leader>gR",
        require("gitsigns").reset_buffer,
        { buffer = bufnr, desc = "[G]it: [R]eset buffer" }
      )

      -- Text object
      vim.keymap.set(
        { "o", "x" },
        "ig",
        ":<C-U>Gitsigns select_hunk<CR>",
        { buffer = bufnr, desc = "inner git hunk" }
      )
      vim.keymap.set(
        { "o", "x" },
        "ag",
        ":<C-U>Gitsigns select_hunk<CR>",
        { buffer = bufnr, desc = "a git hunk" }
      )
    end,
  },
}
