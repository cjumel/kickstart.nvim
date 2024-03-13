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
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      local next_hunk = function()
        gs.next_hunk({
          -- Navigation message is inconsistent with other movements & is displayed far away from
          -- the hunk itself so it's more distracting than helpful
          navigation_message = false,
        })
      end
      local prev_hunk = function()
        gs.prev_hunk({
          -- Navigation message is inconsistent with other movements & is displayed far away from
          -- the hunk itself so it's more distracting than helpful
          navigation_message = false,
        })
      end
      next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(next_hunk, prev_hunk)
      map({ "n", "x", "o" }, "[h", next_hunk, { desc = "Next hunk" })
      map({ "n", "x", "o" }, "]h", prev_hunk, { desc = "Previous hunk" })

      local conflict_marker = "<<<<<<< \\|=======\\|>>>>>>> "
      local next_conflict = function()
        vim.cmd("silent!/" .. conflict_marker)
        vim.cmd("nohlsearch") -- Clear optional search highlights on the conflict marker
      end
      local prev_conflict = function()
        vim.cmd("silent!?" .. conflict_marker)
        vim.cmd("nohlsearch") -- Clear optional search highlights on the conflict marker
      end
      next_conflict, prev_conflict =
        ts_repeat_move.make_repeatable_move_pair(next_conflict, prev_conflict)
      map({ "n", "x", "o" }, "[H", next_conflict, { desc = "Next conflict hunk" })
      map({ "n", "x", "o" }, "]H", prev_conflict, { desc = "Previous conflict hunk" })

      -- Action
      map({ "n", "v" }, "<leader>h", gs.preview_hunk, { desc = "[H]unk" })

      map("n", "<leader>a", gs.stage_hunk, { desc = "[A]dd hunk" })
      map("v", "<leader>a", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[A]dd lines" })
      map("n", "<leader>A", gs.undo_stage_hunk, { desc = "[A]dd-hunk undo" })
      map("n", "<leader>ga", gs.stage_buffer, { desc = "[G]it: [A]dd buffer" })

      map("n", "<leader>r", gs.reset_hunk, { desc = "[R]eset hunk" })
      map("v", "<leader>r", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[R]eset lines" })
      map("n", "<leader>gr", gs.reset_buffer, { desc = "[G]it: [R]eset buffer" })

      map("n", "<leader>gd", function()
        gs.diffthis("~")
      end, { desc = "[G]it: [D]iff" })

      map("n", "<leader>gB", function()
        gs.blame_line({ full = true })
      end, { desc = "[G]it: [B]lame" })

      -- Text objects
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner hunk" })
      map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "a hunk" })
    end,
  },
}
