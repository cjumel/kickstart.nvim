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
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      local next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(function()
        require("gitsigns").next_hunk({ navigation_message = false })
      end, function()
        require("gitsigns").prev_hunk({ navigation_message = false })
      end)
      map({ "n", "x", "o" }, "[h", next_hunk, "Next hunk")
      map({ "n", "x", "o" }, "]h", prev_hunk, "Previous hunk")
      map({ "n", "x", "o" }, "[H", actions.next_conflict, "Next conflict hunk")
      map({ "n", "x", "o" }, "]H", actions.prev_conflict, "Previous conflict hunk")

      -- Hunk actions are implemented with Hydra to avoid the need to type the leader key between
      -- each hunk action. See the `hydra.nvim` plugin configuration for more details.

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
      map({ "n", "v" }, "<leader>gL", function()
        if vim.fn.mode() == "n" then
          require("telescope.builtin").git_bcommits({ prompt_title = "Git Buffer Log" })
        else
          require("telescope.builtin").git_bcommits_range({ prompt_title = "Git Selection Log" })
        end
      end, "[G]it: buffer/selection [L]og")

      -- Text object with custom look ahead feature
      local gs_cache = require("gitsigns.cache")
      local Hunks = require("gitsigns.hunks")

      local api = vim.api
      local cache = gs_cache.cache

      --- Get the hunk under the cursor or nil if there is none.
      --- Function is directly adapted from `gitsigns.actions`.
      --- @return Gitsigns.Hunk.Hunk? hunk
      --- @return integer? index
      local function get_cursor_hunk()
        if not cache[bufnr] then
          return
        end
        local hunks = {}
        vim.list_extend(hunks, cache[bufnr].hunks or {})
        vim.list_extend(hunks, cache[bufnr].hunks_staged or {})

        local lnum = api.nvim_win_get_cursor(0)[1]
        return Hunks.find_hunk(lnum, hunks)
      end

      local function select_hunk()
        -- Adapt the "<C-U>" from the original command ":<C-U>Gitsigns select_hunk<CR>"
        -- Taken from https://github.com/neovim/neovim/discussions/24055
        vim.cmd('execute "normal \\<ESC>"')

        if get_cursor_hunk() == nil then
          gs.next_hunk({ wrap = false, navigation_message = false })
        end

        gs.select_hunk()
      end

      map({ "x", "o" }, "gh", select_hunk, "Hunk")
    end,
  },
}
