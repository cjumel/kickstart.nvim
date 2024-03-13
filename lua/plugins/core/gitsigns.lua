-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua. This plugin brings
-- buffer-centric features, like signs to mark git hunks, or functions to stage them.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "+" },
    },
    -- Enable Gitsigns on untracked files to avoid mistaking them with tracked ones without change
    -- and enable keymaps to stage them
    attach_to_untracked = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      ---@param mode string|table<string>
      ---@param lhs string
      ---@param rhs fun()|string
      ---@param desc string
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
      end

      -- Navigation
      -- Navigation messages are inconsistent with other movements & are displayed far away from
      -- the hunk itself so it's more distracting than helpful
      local next_hunk = function()
        gs.next_hunk({ navigation_message = false })
      end
      local prev_hunk = function()
        gs.prev_hunk({ navigation_message = false })
      end
      next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(next_hunk, prev_hunk)
      map({ "n", "x", "o" }, "[h", next_hunk, "Next hunk")
      map({ "n", "x", "o" }, "]h", prev_hunk, "Previous hunk")

      local conflict_marker = "<<<<<<< \\|=======\\|>>>>>>> "
      -- "nohlsearch" clears optional search highlights on the conflict marker
      local next_conflict = function()
        vim.cmd("silent!/" .. conflict_marker)
        vim.cmd("nohlsearch")
      end
      local prev_conflict = function()
        vim.cmd("silent!?" .. conflict_marker)
        vim.cmd("nohlsearch")
      end
      next_conflict, prev_conflict =
        ts_repeat_move.make_repeatable_move_pair(next_conflict, prev_conflict)
      map({ "n", "x", "o" }, "[H", next_conflict, "Next conflict hunk")
      map({ "n", "x", "o" }, "]H", prev_conflict, "Previous conflict hunk")

      -- Actions
      map({ "n", "v" }, "<leader>h", gs.preview_hunk, "[H]unk")

      map("n", "<leader>a", gs.stage_hunk, "[A]dd hunk")
      map("v", "<leader>a", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "[A]dd lines")
      map("n", "<leader>A", gs.undo_stage_hunk, "[A]dd-hunk undo")
      map("n", "<leader>ga", gs.stage_buffer, "[G]it: [A]dd buffer")

      map("n", "<leader>r", gs.reset_hunk, "[R]eset hunk")
      map("v", "<leader>r", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "[R]eset lines")
      map("n", "<leader>gr", gs.reset_buffer, "[G]it: [R]eset buffer")

      map("n", "<leader>gd", function()
        gs.diffthis("~")
      end, "[G]it: [D]iff")

      map("n", "<leader>gB", function()
        gs.blame_line({ full = true })
      end, "[G]it: [B]lame")

      -- Text objects
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "inner hunk")
      map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", "a hunk")
    end,
  },
}
