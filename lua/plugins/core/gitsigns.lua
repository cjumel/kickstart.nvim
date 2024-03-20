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

      ---@param mode string|table<string>
      ---@param lhs string
      ---@param rhs fun()|string
      ---@param desc string
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
      end

      -- Navigation
      local actions = require("actions")
      map({ "n", "x", "o" }, "[h", actions.next_hunk, "Next hunk")
      map({ "n", "x", "o" }, "]h", actions.prev_hunk, "Previous hunk")
      map({ "n", "x", "o" }, "[H", actions.next_conflict, "Next conflict hunk")
      map({ "n", "x", "o" }, "]H", actions.prev_conflict, "Previous conflict hunk")

      -- Hunk actions
      -- These actions are implemented with Hydra to avoid the need to type the leader key between
      -- each hunk action
      local Hydra = require("hydra")
      Hydra({
        body = "<leader>h",
        config = {
          desc = "[H]unk manager",
          color = "pink", -- For synchron buffer actions
          on_exit = actions.clear_window, -- Leave hunk preview when leaving the hunk manager
          -- Setting `buffer=true` or `buffer=bufnr` makes the hunk manager keymaps only work in a
          -- single buffer, while still being able to switch buffer (as `foreign_keys="run"` can't
          -- be overriden for pink Hydra). In that case, the Hydra is still opened but the keymaps
          -- don't work in the new buffer, which is quite confusing.
          buffer = nil,
        },
        mode = { "n", "v" },
        hint = [[
                                          Hunk manager                                          
   _,_ ➜ Next hunk                _p_ ➜ [P]review hunk              _u_ ➜ [U]ndo stage   
   _;_ ➜ Previous hunk            _s_ ➜ [S]tage hunk or selection   _x_ ➜ Discard hunk or selection   
   _d_ ➜ Toggle [D]eleted hunks   
]],
        heads = {
          { ",", actions.next_hunk },
          { ";", actions.prev_hunk },
          { "d", gs.toggle_deleted },
          { "p", gs.preview_hunk },
          {
            "s",
            function()
              if vim.fn.mode() == "n" then
                gs.stage_hunk()
              else
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end
            end,
          },
          { "u", gs.undo_stage_hunk },
          {
            "x",
            function()
              if vim.fn.mode() == "n" then
                gs.reset_hunk()
              else
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end
            end,
          },
          -- Exist must be with <Esc> for compatibility with clear window action
          { "<Esc>", nil, { exit = true, desc = false } },
        },
      })

      -- General git actions
      map("n", "<leader>ga", gs.stage_buffer, "[G]it: [A]dd buffer")
      map("n", "<leader>gu", gs.reset_buffer_index, "[G]it: [U]nstage buffer")
      map("n", "<leader>gx", gs.reset_buffer, "[G]it: discard buffer changes")
      map("n", "<leader>gd", function()
        gs.diffthis("~")
      end, "[G]it: [D]iff buffer")
      map("n", "<leader>gB", function()
        gs.blame_line({ full = true })
      end, "[G]it: [B]lame line")
      map("n", "<leader>gL", function()
        require("telescope.builtin").git_bcommits({ prompt_title = "Git Buffer Log" })
      end, "[G]it: buffer [L]og")
      map("v", "<leader>g", function()
        require("telescope.builtin").git_bcommits_range({ prompt_title = "Git Selection Log" })
      end, "[G]it: selection log")

      -- Text objects
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "inner hunk")
      map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", "a hunk")
    end,
  },
}
