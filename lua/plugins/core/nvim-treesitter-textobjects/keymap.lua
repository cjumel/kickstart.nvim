local M = {}

--- Wrapper around `vim.keymap.set` for repeatable move pairs.
--- This wrapper takes both "next" and "previous" move keymaps as arguments and creates a pair of repeatable keymaps
--- using `nvim-treesitter.textobjects`, in "n", "x" and "o" modes (usual modes for move keymaps).
---@param key string The keymap key, to use in addition to "[" or "]" to define the keymaps lhs.
---@param forward_move_fn function The function to move in the forward direction to define one of the keymaps rhs.
---@param backward_move_fn function The function to move in the backward direction to define the other keymap rhs.
---@param name string The keymap name, to use in addition to "Next " or "Previous " to define the keymaps descriptions.
---@param opts table|nil The options to use for both keymaps.
---@return nil
function M.set_move_pair(key, forward_move_fn, backward_move_fn, name, opts)
  local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")

  forward_move_fn, backward_move_fn = ts_repeatable_move.make_repeatable_move_pair(forward_move_fn, backward_move_fn)
  opts = opts or {}
  local forward_move_opts = vim.tbl_deep_extend("force", { desc = "Next " .. name }, opts)
  local backward_move_opts = vim.tbl_deep_extend("force", { desc = "Previous " .. name }, opts)

  vim.keymap.set({ "n", "x", "o" }, "[" .. key, forward_move_fn, forward_move_opts)
  vim.keymap.set({ "n", "x", "o" }, "]" .. key, backward_move_fn, backward_move_opts)
end

--- Wrapper around `vim.keymap.set` for buffer-specific repeatable move pairs.
--- This wrapper takes both "next" and "previous" move keymaps as arguments and creates a pair of repeatable keymaps
--- using `nvim-treesitter.textobjects`, in "n", "x" and "o" modes (usual modes for move keymaps).
---@param key string The keymap key, to use in addition to "[" or "]" to define the keymaps lhs.
---@param forward_move_fn function The function to move in the forward direction to define one of the keymaps rhs.
---@param backward_move_fn function The function to move in the backward direction to define the other keymap rhs.
---@param name string The keymap name, to use in addition to "Next " or "Previous " to define the keymaps descriptions.
---@return nil
function M.set_local_move_pair(key, forward_move_fn, backward_move_fn, name)
  M.set_move_pair(key, forward_move_fn, backward_move_fn, name, { buffer = true })
end

return M
