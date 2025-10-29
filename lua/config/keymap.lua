local M = {}

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
function M.set_buffer(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param key string
---@param rhs_next function
---@param rhs_prev function
---@param name string
---@param other_key string|nil
function M.set_pair(key, rhs_next, rhs_prev, name, other_key)
  local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
  other_key = other_key or key
  rhs_next, rhs_prev = ts_repeatable_move.make_repeatable_move_pair(rhs_next, rhs_prev)
  vim.keymap.set({ "n", "x", "o" }, "]" .. key, rhs_next, { desc = "Next " .. name })
  vim.keymap.set({ "n", "x", "o" }, "[" .. other_key, rhs_prev, { desc = "Previous " .. name })
end

---@param key string
---@param rhs_next function
---@param rhs_prev function
---@param name string
---@param other_key string|nil
function M.set_buffer_pair(key, rhs_next, rhs_prev, name, other_key)
  local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
  other_key = other_key or key
  rhs_next, rhs_prev = ts_repeatable_move.make_repeatable_move_pair(rhs_next, rhs_prev)
  vim.keymap.set({ "n", "x", "o" }, "]" .. key, rhs_next, { desc = "Next " .. name, buffer = true })
  vim.keymap.set({ "n", "x", "o" }, "[" .. other_key, rhs_prev, { desc = "Previous " .. name, buffer = true })
end

return M
