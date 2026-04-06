return {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    signs = { add = { text = "+" }, change = { text = "~" }, untracked = { text = "" } },
    signs_staged = { add = { text = "+" }, change = { text = "~" }, untracked = { text = "" } },
    attach_to_untracked = true, -- Enables keymap to stage untracked files or hunks
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local map = require("config.utils").get_buffer_map_function(bufnr)

      -- General keymaps
      map("n", "<leader>gs", gitsigns.stage_buffer, { desc = "[G]it: [S]tage buffer" })
      map("n", "<leader>gu", gitsigns.reset_buffer_index, { desc = "[G]it: [U]nstage buffer" })
      map("n", "<leader>gx", gitsigns.reset_buffer, { desc = "[G]it: discard buffer changes" })
      map("n", "<leader>gp", function() gitsigns.blame_line({ full = true }) end, { desc = "[G]it: [P]review blame" })
      map("n", "<leader>gd", gitsigns.diffthis, { desc = "[G]it: [D]iff buffer" })

      -- Navigation keymaps
      local function next_hunk() gitsigns.nav_hunk("next") end
      local function prev_hunk() gitsigns.nav_hunk("next") end
      map({ "n", "x", "o" }, "]h", next_hunk, { desc = "Next hunk" })
      map({ "n", "x", "o" }, "[h", prev_hunk, { desc = "Previous hunk" })
      local function next_staged_hunk() gitsigns.nav_hunk("next", { target = "staged" }) end
      local function prev_staged_hunk() gitsigns.nav_hunk("prev", { target = "staged" }) end
      map({ "n", "x", "o" }, "]s", next_staged_hunk, { desc = "Next staged hunk" })
      map({ "n", "x", "o" }, "[s", prev_staged_hunk, { desc = "Previous staged hunk" })

      -- Text object
      map({ "x", "o" }, "gh", gitsigns.select_hunk, { desc = "Hunk" })
    end,
  },
}
