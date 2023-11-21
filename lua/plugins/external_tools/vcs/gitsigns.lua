-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua. This plugin brings
-- buffer-centric features, like signs to mark git hunks, or functions to stage them.

local utils = require("plugins.external_tools.vcs.utils.gitsigns")

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
        ts_repeat_move.make_repeatable_move_pair(utils.next_conflict, utils.prev_conflict)

      -- Navigation keymaps
      map({ "n", "x", "o" }, "[h", next_hunk_repeat, { desc = "Next hunk" })
      map({ "n", "x", "o" }, "]h", prev_hunk_repeat, { desc = "Previous hunk" })
      map({ "n", "x", "o" }, "[H", next_conflict_repeat, { desc = "Next conflict hunk" })
      map({ "n", "x", "o" }, "]H", prev_conflict_repeat, { desc = "Previous conflict hunk" })

      -- Action keymaps
      map({ "n", "v" }, "<leader><TAB>", gs.preview_hunk, { desc = "Preview hunk (Git)" })

      map("n", "<leader>a", gs.stage_hunk, { desc = "[A]dd hunk (Git)" })
      map("v", "<leader>a", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[A]dd lines (Git)" })
      map("n", "<leader>A", gs.stage_buffer, { desc = "[A]dd buffer (Git)" })

      map("n", "<leader>r", gs.reset_hunk, { desc = "[R]eset hunk (Git)" })
      map("v", "<leader>r", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[R]eset lines (Git)" })
      map("n", "<leader>R", gs.reset_buffer, { desc = "[R]eset buffer (Git)" })

      map("n", "<leader>u", gs.undo_stage_hunk, { desc = "[U]ndo 'add hunk' (Git)" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner hunk" })
      map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "a hunk" })
    end,
  },
}
