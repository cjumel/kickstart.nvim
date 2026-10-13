local M = {}

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map_buffer(mode, lhs, rhs, opts)
  opts.buf = 0
  vim.keymap.set(mode, lhs, rhs, opts)
end
M.map_buffer = map_buffer

---@param buf number
local function get_buffer_map_function(buf)
  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  local function map(mode, lhs, rhs, opts)
    opts.buf = buf
    vim.keymap.set(mode, lhs, rhs, opts)
  end
  return map
end
M.get_buffer_map_function = get_buffer_map_function

---@param buf number
local function get_buffer_unmap_function(buf)
  ---@param mode string|string[]
  ---@param lhs string
  local function unmap(mode, lhs) pcall(vim.keymap.del, mode, lhs, { buf = buf }) end
  return unmap
end
M.get_buffer_unmap_function = get_buffer_unmap_function

return M
