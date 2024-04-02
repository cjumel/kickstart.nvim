local M = {}

--- Wrapper around `vim.keymap.set` for all modes keymaps.
---@param mode string|table<string> Mode(s) of the keymap.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

--- Wrapper around `vim.keymap.set` for normal mode keymaps.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.nmap(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set("n", lhs, rhs, opts)
end

--- Wrapper around `vim.keymap.set` for insert mode keymaps.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.imap(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set("i", lhs, rhs, opts)
end

--- Wrapper around `vim.keymap.set` for cmdline mode keymaps.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.cmap(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set("c", lhs, rhs, opts)
end

--- Wrapper around `vim.keymap.set` for insert & cmdline mode keymaps.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.icmap(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set({ "i", "c" }, lhs, rhs, opts)
end

--- Wrapper around `vim.keymap.set` for visual mode keymaps.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.vmap(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set("v", lhs, rhs, opts)
end

--- Wrapper around `vim.keymap.set` for operator-pending mode keymaps.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.omap(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set({ "x", "o" }, lhs, rhs, opts)
end

--- Wrapper around `vim.keymap.set` for movement keymaps.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.mmap(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set({ "n", "x", "o" }, lhs, rhs, opts)
end

--- Wrapper around `vim.keymap.set` for movement pair keymaps. This wrapper takes both keymaps as
--- arguments and creates a pair of repeatable keymaps using `nvim-treesitter`.
---@param lhs table<string> Pair of next & previous left-hand sides of the keymaps.
---@param rhs table<string> Pair of next & previous right-hand sides of the keymaps.
---@param desc table<string> Pair of next & previous descriptions of the keymaps.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.mpmap(lhs, rhs, desc, opts)
  local next_lhs, prev_lhs = lhs[1], lhs[2]
  local next_func, prev_func = rhs[1], rhs[2]
  local next_desc, prev_desc = desc[1], desc[2]

  local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
  next_func, prev_func = ts_repeat_move.make_repeatable_move_pair(next_func, prev_func)

  M.mmap(next_lhs, next_func, next_desc, opts)
  M.mmap(prev_lhs, prev_func, prev_desc, opts)
end

return M
