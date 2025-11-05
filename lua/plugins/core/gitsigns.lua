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
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map("n", "<leader>gs", gitsigns.stage_buffer, { desc = "[G]it: [S]tage buffer" })
      map("n", "<leader>gu", gitsigns.reset_buffer_index, { desc = "[G]it: [U]nstage buffer" })
      map("n", "<leader>gx", gitsigns.reset_buffer, { desc = "[G]it: discard buffer changes" })
      map("n", "<leader>gp", function() gitsigns.blame_line({ full = true }) end, { desc = "[G]it: [P]review blame" })
      map("n", "<leader>gd", gitsigns.diffthis, { desc = "[G]it: [D]iff buffer" })
      map({ "x", "o" }, "gh", gitsigns.select_hunk, { desc = "Hunk" })
    end,
  },
}
