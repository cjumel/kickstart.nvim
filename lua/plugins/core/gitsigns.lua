-- gitsigns.nvim
--
-- gitsigns.nvim provides Git integration for buffers, with super fast Git decorations and utilities implemented purely
-- in Lua. With its buffer-centric approach, this plugin is super complementary with other general Git integration
-- plugins, like Neogit, and is a must for me.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    signs = { add = { text = "+" }, change = { text = "~" }, untracked = { text = "" } },
    signs_staged_enable = false,
    attach_to_untracked = true,
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      ---@param mode string|string[] The mode(s) of the keymap.
      ---@param lhs string The left-hand side of the keymap.
      ---@param rhs string|function The right-hand side of the keymap.
      ---@param desc string The description of the keymap.
      local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr }) end

      map("n", "<leader>gs", gitsigns.stage_buffer, "[G]it: [S]tage buffer")
      map("n", "<leader>gu", gitsigns.reset_buffer_index, "[G]it: [U]nstage buffer")
      map("n", "<leader>gx", gitsigns.reset_buffer, "[G]it: discard buffer changes")
      map("n", "<leader>gp", function() gitsigns.blame_line({ full = true }) end, "[G]it: [P]reviw blame")
      map("n", "<leader>gd", function() gitsigns.diffthis("~") end, "[G]it: buffer [D]iff")
      map({ "x", "o" }, "gh", ":<C-U>Gitsigns select_hunk<CR>", "Hunk")
    end,
  },
}
