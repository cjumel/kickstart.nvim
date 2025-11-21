return {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    signs = { add = { text = "+" }, change = { text = "~" }, untracked = { text = "" } },
    signs_staged = { add = { text = "+" }, change = { text = "~" }, untracked = { text = "" } },
    attach_to_untracked = true, -- Enables keymap to stage untracked files or hunks
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      ---@param mode string|string[]
      ---@param lhs string
      ---@param rhs string|function
      ---@param opts table
      local function map(mode, lhs, rhs, opts)
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- General keymaps
      map("n", "<leader>gs", gitsigns.stage_buffer, { desc = "[G]it: [S]tage buffer" })
      map("n", "<leader>gu", gitsigns.reset_buffer_index, { desc = "[G]it: [U]nstage buffer" })
      map("n", "<leader>gx", gitsigns.reset_buffer, { desc = "[G]it: discard buffer changes" })
      map("n", "<leader>gp", function() gitsigns.blame_line({ full = true }) end, { desc = "[G]it: [P]review blame" })
      map("n", "<leader>gd", gitsigns.diffthis, { desc = "[G]it: [D]iff buffer" })

      -- Navigation keymaps
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      local next_unstaged_hunk, prev_unstaged_hunk = ts_repeat_move.make_repeatable_move_pair(
        function() gitsigns.nav_hunk("next") end, ---@diagnostic disable-line: param-type-mismatch
        function() gitsigns.nav_hunk("prev") end ---@diagnostic disable-line: param-type-mismatch
      )
      local next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(
        function() gitsigns.nav_hunk("next", { target = "all" }) end, ---@diagnostic disable-line: param-type-mismatch
        function() gitsigns.nav_hunk("prev", { target = "all" }) end ---@diagnostic disable-line: param-type-mismatch
      )
      map({ "n", "x", "o" }, "]h", next_unstaged_hunk, { desc = "Next unstaged hunk" })
      map({ "n", "x", "o" }, "[h", prev_unstaged_hunk, { desc = "Previous unstaged hunk" })
      map({ "n", "x", "o" }, "]H", next_hunk, { desc = "Next hunk" })
      map({ "n", "x", "o" }, "[H", prev_hunk, { desc = "Previous hunk" })

      -- Text object
      map({ "x", "o" }, "gh", gitsigns.select_hunk, { desc = "Hunk" })
    end,
  },
}
