local M = {}

--- Wrapper around `vim.keymap.set` for repeatable move pairs.
--- This wrapper takes both "next" and "previous" move keymaps as arguments and creates a pair of
--- repeatable keymaps using `nvim-treesitter.textobjects` in "n", "x" and "o" modes (usual modes
--- for move keymaps).
---@param lhs_pair table<string> Left-hand side of the "next" and "previous" move keymaps.
---@param rhs_pair table<function> Right-hand side of the "next" and "previous" move keymaps.
---@param opts_pair table<table> Options passed to `vim.keymap.set` for the "next" and "previous"
--- move keymaps.
---@return nil
function M.set_move_pair(lhs_pair, rhs_pair, opts_pair)
  local next_lhs, prev_lhs = lhs_pair[1], lhs_pair[2]
  local next_rhs, prev_rhs = rhs_pair[1], rhs_pair[2]
  local next_opts, prev_opts = opts_pair[1], opts_pair[2]

  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  next_rhs, prev_rhs = ts_repeat_move.make_repeatable_move_pair(next_rhs, prev_rhs)

  vim.keymap.set({ "n", "x", "o" }, next_lhs, next_rhs, next_opts)
  vim.keymap.set({ "n", "x", "o" }, prev_lhs, prev_rhs, prev_opts)
end

--- Output a function which creates buffer-local keymaps.
---@param bufnr number The buffer number to create keymaps for.
---@return function
function M.get_buffer_local_map(bufnr)
  ---@param mode string|string[] The mode(s) of the keymap.
  ---@param lhs string The left-hand side of the keymap.
  ---@param rhs string|function The right-hand side of the keymap.
  ---@param desc string The description of the keymap.
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
  end

  return map
end

return M
