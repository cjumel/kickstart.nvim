local M = {}

--- Output a function which creates buffer-local keymaps.
---@param bufnr number The buffer number to create keymaps for.
---@return function
function M.get_buffer_local_map(bufnr)
  ---@param mode string|string[] The mode(s) of the keymap.
  ---@param lhs string The left-hand side of the keymap.
  ---@param rhs string|function The right-hand side of the keymap.
  ---@param desc string The description of the keymap.
  ---@param opts table|nil Additional options for the keymap.
  local function map(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  return map
end

return M
