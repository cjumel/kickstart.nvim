-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua. This plugin brings
-- buffer-centric features, like signs to mark git hunks, or functions to stage them.

return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvimtools/hydra.nvim",
  },
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

      local utils = require("utils")
      local nmap = utils.keymap.nmap
      local omap = utils.keymap.omap
      local mpmap = utils.keymap.mpmap

      local opts = { buffer = bufnr }

      -- Navigation keymaps
      mpmap({ "[h", "]h" }, {
        function() gs.next_hunk({ navigation_message = false }) end,
        function() gs.prev_hunk({ navigation_message = false }) end,
      }, { "Next hunk", "Previous hunk" }, opts)

      -- General git actions
      nmap("<leader>ga", gs.stage_buffer, "[G]it: [A]dd buffer", opts)
      nmap("<leader>gu", gs.reset_buffer_index, "[G]it: [U]nstage buffer", opts)
      nmap("<leader>gx", gs.reset_buffer, "[G]it: discard buffer changes", opts)
      nmap("<leader>gd", function() gs.diffthis("~") end, "[G]it: [D]iff buffer", opts)
      nmap("<leader>gB", function() gs.blame_line({ full = true }) end, "[G]it: [B]lame line", opts)

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

      omap("gh", select_hunk, "Hunk", opts)
    end,
  },
  config = function(_, opts)
    local gs = require("gitsigns")

    gs.setup(opts)

    -- Hunk actions are implemented with Hydra to avoid the need to type the leader key between
    -- each hunk action. When tied to a specific buffer, the Hydra cannot perform actions on other
    -- buffers (but it can switch to them), hence it is defined globally here, without buffer.
    local Hydra = require("hydra")

    local actions = require("actions")

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
   ^ ^                            ^ ^        Hunk manager           ^ ^                            
   _,_ ➜ Next hunk                _p_ ➜ [P]review hunk              _u_ ➜ [U]ndo stage   
   _;_ ➜ Previous hunk            _s_ ➜ [S]tage hunk/selection      _x_ ➜ Discard hunk/selection   
   _d_ ➜ Toggle [D]eleted hunks   
]],
      heads = {
        -- "," & ";" are not repeatable on purpose, to be able to resume the previous movement
        -- actions after leaving the hydra
        { ",", function() gs.next_hunk({ navigation_message = false }) end },
        { ";", function() gs.prev_hunk({ navigation_message = false }) end },
        { "d", function() gs.toggle_deleted() end },
        { "p", function() gs.preview_hunk() end },
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
        { "u", function() gs.undo_stage_hunk() end },
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
  end,
}
