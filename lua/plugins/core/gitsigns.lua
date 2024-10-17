-- gitsigns.nvim
--
-- gitsigns.nvim provides Git integration for buffers, with super fast Git decorations and utilities implemented purely
-- in Lua. With its buffer-centric approach, this plugin is super complementary with other general Git integration
-- plugins, like Neogit, and is a must for me.

return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvimtools/hydra.nvim" },
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    signs = { add = { text = "+" }, change = { text = "~" }, untracked = { text = "" } }, -- Simplify some of the signs
    signs_staged_enable = false, -- Don't show signs for staged changes
    attach_to_untracked = true, -- Attach on untracked files to enable keymaps (even if corresponding sign is disabled)
    on_attach = function(bufnr)
      local actions = require("plugins.core.gitsigns.actions")
      local gitsigns = require("gitsigns")
      local keymap = require("keymap")

      local map = keymap.get_buffer_local_map(bufnr)

      -- General git actions
      map("n", "<leader>gs", gitsigns.stage_buffer, "[G]it: [S]tage buffer")
      map("n", "<leader>gu", gitsigns.reset_buffer_index, "[G]it: [U]nstage buffer")
      map("n", "<leader>gx", gitsigns.reset_buffer, "[G]it: discard buffer changes")
      map("n", "<leader>gK", function() gitsigns.blame_line({ full = true }) end, "[G]it: hover blame")
      map("n", "<leader>gd", function() gitsigns.diffthis("~") end, "[G]it: buffer [D]iff")

      -- Hunk text object (with custom look ahead feature)
      map({ "x", "o" }, "gh", actions.select_hunk, "Hunk")
    end,
  },
}
