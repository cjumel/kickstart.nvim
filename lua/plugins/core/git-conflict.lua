return {
  "akinsho/git-conflict.nvim",
  event = { "BufReadPre" },
  opts = {
    default_mappings = false, -- Keymaps are implemented in Hydra.nvim and nvim-treesitter-textobjects
    disable_diagnostics = true,
  },
  config = function(_, opts)
    local git_conflict = require("git-conflict")
    git_conflict.setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "GitConflictDetected",
      callback = function(event)
        ---@param mode string|string[]
        ---@param lhs string
        ---@param rhs string|function
        ---@param opts_ table
        local function map(mode, lhs, rhs, opts_)
          opts_.buffer = event.buf
          vim.keymap.set(mode, lhs, rhs, opts_)
        end

        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
        local next_conflict, prev_conflict = ts_repeat_move.make_repeatable_move_pair(
          function() git_conflict.find_next("ours") end,
          function() git_conflict.find_prev("ours") end
        )
        map({ "n", "x", "o" }, "]<M-c>", next_conflict, { desc = "Next conflict" })
        map({ "n", "x", "o" }, "[<M-c>", prev_conflict, { desc = "Previous conflict" })
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "GitConflictResolved",
      callback = function(event)
        ---@param mode string|string[]
        ---@param lhs string
        local function unmap(mode, lhs) pcall(vim.keymap.del, mode, lhs, { buffer = event.buf }) end

        unmap({ "n", "x", "o" }, "]<M-c>")
        unmap({ "n", "x", "o" }, "[<M-c>")
      end,
    })
  end,
}
