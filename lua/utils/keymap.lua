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

--- Wrapper around `vim.keymap.set` for normal & visual mode keymaps.
---@param lhs string Left-hand side of the keymap.
---@param rhs string|function Right-hand side of the keymap.
---@param desc string|nil Description of the keymap.
---@param opts table|nil Remaining options passed to `vim.keymap.set`.
---@return nil
function M.nvmap(lhs, rhs, desc, opts)
  opts = opts or {}
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set({ "n", "v" }, lhs, rhs, opts)
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

return M
