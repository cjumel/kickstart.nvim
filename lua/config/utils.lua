local M = {}

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map_buffer(mode, lhs, rhs, opts)
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end
M.map_buffer = map_buffer

---@param bufnr number
local function get_buffer_map_function(bufnr)
  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  local function map(mode, lhs, rhs, opts)
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end
  return map
end
M.get_buffer_map_function = get_buffer_map_function

---@param bufnr number
local function get_buffer_unmap_function(bufnr)
  ---@param mode string|string[]
  ---@param lhs string
  local function unmap(mode, lhs) pcall(vim.keymap.del, mode, lhs, { buffer = bufnr }) end
  return unmap
end
M.get_buffer_unmap_function = get_buffer_unmap_function

return M
