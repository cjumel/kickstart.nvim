-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua. This plugin brings
-- buffer-centric features, like signs to mark git hunks, or functions to stage them.

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
    sign_priority = 6, -- Default value
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
      map({ "n", "x", "o" }, "[h", next_hunk_repeat, { desc = "Next Git hunk" })
      map({ "n", "x", "o" }, "]h", prev_hunk_repeat, { desc = "Previous Git hunk" })
      map({ "n", "x", "o" }, "[H", next_conflict_repeat, { desc = "Next Git conflict hunk" })
      map({ "n", "x", "o" }, "]H", prev_conflict_repeat, { desc = "Previous Git conflict hunk" })

      -- Action keymaps
      map({ "n", "v" }, "<leader><TAB>", gs.preview_hunk, { desc = "Expand Git hunk" })

      map("n", "<leader>a", gs.stage_hunk, { desc = "[A]dd Git hunk" })
      map("v", "<leader>a", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[A]dd Git lines" })
      map("n", "<leader>A", gs.undo_stage_hunk, { desc = "[A]dd-Git-hunk undo" })
      map("n", "<leader>ga", gs.stage_buffer, { desc = "[G]it: [A]dd buffer" })

      map("n", "<leader>r", gs.reset_hunk, { desc = "[R]eset Git hunk" })
      map("v", "<leader>r", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[R]eset Git lines" })
      map("n", "<leader>gr", gs.reset_buffer, { desc = "[G]it: [R]eset buffer" })

      map("n", "<leader>gd", function()
        gs.diffthis("~")
      end, { desc = "[G]it: [D]iff" })

      map("n", "<leader>gB", function()
        gs.blame_line({ full = true })
      end, { desc = "[G]it: [B]lame" })

      map("n", "<leader>,d", gs.toggle_deleted, { desc = "Settings: toggle [D]eleted lines" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner Git hunk" })
      map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "a Git hunk" })
    end,
  },
}
