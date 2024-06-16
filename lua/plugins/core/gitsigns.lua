-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua. This plugin brings buffer-centric features,
-- like signs to mark git hunks, or functions to stage them.

return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvimtools/hydra.nvim" },
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
    -- Enable Gitsigns on untracked files to avoid mistaking them with tracked ones without change and enable keymaps
    -- to stage them
    attach_to_untracked = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local utils = require("utils")

      local map = utils.keymap.get_buffer_local_map(bufnr)

      -- General git actions
      map("n", "<leader>gs", gs.stage_buffer, "[G]it: [S]tage buffer")
      map("n", "<leader>gu", gs.reset_buffer_index, "[G]it: [U]nstage buffer")
      map("n", "<leader>gx", gs.reset_buffer, "[G]it: discard buffer changes")
      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "[G]it: line [B]lame")
      map("n", "<leader>gd", function() gs.diffthis("~") end, "[G]it: buffer [D]iff")
      map("n", "<leader>gh", "<cmd>Gitsigns setloclist<CR>", "[G]it: buffer [H]unks") -- Lazy-load Trouble

      -- Navigation keymaps
      utils.keymap.set_move_pair({ "[h", "]h" }, {
        function() gs.next_hunk({ navigation_message = false }) end,
        function() gs.prev_hunk({ navigation_message = false }) end,
      }, { { desc = "Next hunk", buffer = bufnr }, { desc = "Previous hunk", buffer = bufnr } })

      -- Text object with custom look ahead feature
      local gs_cache = require("gitsigns.cache")
      local Hunks = require("gitsigns.hunks")

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
        local lnum = vim.api.nvim_win_get_cursor(0)[1]
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
  config = function(_, opts)
    local gs = require("gitsigns")
    gs.setup(opts)

    -- Hunk actions are implemented with Hydra to remove the need to type the <leader> key between each hunk action.
    local Hydra = require("hydra")
    local hydra_configs = require("plugins.ui.hydra.configs")
    Hydra(hydra_configs.hunk)
  end,
}
