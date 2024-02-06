-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua, which make it and fugitive
-- perfect for a complete git integration.

local conflict_marker = "<<<<<<< \\|=======\\|>>>>>>> "
local next_conflict = function()
  vim.cmd("silent!/" .. conflict_marker)
end
local prev_conflict = function()
  vim.cmd("silent!?" .. conflict_marker)
end

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
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Make navigation functions repeatable
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      local next_hunk_repeat, prev_hunk_repeat =
        ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      local next_conflict_repeat, prev_conflict_repeat =
        ts_repeat_move.make_repeatable_move_pair(next_conflict, prev_conflict)

      -- Navigation keymaps
      map({ "n", "x", "o" }, "[g", next_hunk_repeat, { desc = "Next Git hunk" })
      map({ "n", "x", "o" }, "]g", prev_hunk_repeat, { desc = "Previous Git hunk" })
      map({ "n", "x", "o" }, "[G", next_conflict_repeat, { desc = "Next Git conflict" })
      map({ "n", "x", "o" }, "]G", prev_conflict_repeat, { desc = "Previous Git conflict" })

      -- Action keymaps
      map("n", "<leader>gp", gs.preview_hunk, { desc = "[G]it: [P]review hunk" })
      map("n", "<leader>ga", gs.stage_hunk, { desc = "[G]it: [A]dd hunk" })
      map("v", "<leader>ga", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[G]it: [A]dd lines" })
      map("n", "<leader>gA", gs.stage_buffer, { desc = "[G]it: [A]dd buffer" })
      map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "[G]it: [U]ndo 'add hunk'" })
      map("n", "<leader>gr", gs.reset_hunk, { desc = "[G]it: [R]eset hunk" })
      map("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[G]it: [R]eset lines" })
      map("n", "<leader>gR", gs.reset_buffer, { desc = "[G]it: [R]eset buffer" })

      -- Text object
      map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner Git hunk" })
      map({ "o", "x" }, "ag", ":<C-U>Gitsigns select_hunk<CR>", { desc = "a Git hunk" })
    end,
  },
}
