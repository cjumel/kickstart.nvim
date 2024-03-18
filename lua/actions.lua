local M = {}

-- [[ Redefine builtin actions ]]

local no_indent_filetype_prefixes = {
  "dap-", -- In dap & dapui, it doesn't work well with sidebar windows (e.g. break the repl)
  "dapui_",
}

--- Smart version of `a` action to automatically indent when used in empty line.
M.smart_a = function()
  for _, prefix in ipairs(no_indent_filetype_prefixes) do
    if vim.bo.filetype:sub(1, #prefix) == prefix then
      return "a"
    end
  end

  if string.match(vim.api.nvim_get_current_line(), "%g") == nil then
    return '"_cc' -- Save to black hole register to avoid polluting the default register
  end
  return "a"
end

--- Smart version of `i` action to automatically indent when used in empty line.
M.smart_i = function()
  for _, prefix in ipairs(no_indent_filetype_prefixes) do
    if vim.bo.filetype:sub(1, #prefix) == prefix then
      return "a"
    end
  end

  if string.match(vim.api.nvim_get_current_line(), "%g") == nil then
    return '"_cc' -- Save to black hole register to avoid polluting the default register
  end
  return "i"
end

--- Smart version of `dd` action to avoid saving deleted empty lines in register.
M.smart_dd = function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end

-- [[ General actions ]]

M.clear_window = function()
  -- Clear search highlights in case `vim.o.hlsearch` is true
  vim.cmd("nohlsearch")

  -- Dismiss Noice messages if Noice is loaded
  if package.loaded.noice ~= nil then
    require("noice").cmd("dismiss")
  end

  -- If zen-mode is loaded, fetch its window ids to avoid closing them
  local zen_mode_win = nil -- Main window
  local zen_mode_bg_win = nil -- Background window
  if package.loaded["zen-mode"] ~= nil then
    local zen_mode_view = require("zen-mode.view")
    if zen_mode_view.is_open() then
      zen_mode_win = zen_mode_view.win
      zen_mode_bg_win = zen_mode_view.bg_win
    end
  end

  -- Clear remaining relative windows (e.g. preview or hover floating windows) except the zen-mode
  -- windows
  for _, id in ipairs(vim.api.nvim_list_wins()) do
    if
      vim.api.nvim_win_get_config(id).relative ~= ""
      and id ~= zen_mode_win
      and id ~= zen_mode_bg_win
    then
      vim.api.nvim_win_close(id, false)
    end
  end
end

M.hover = function()
  -- If nvim-ufo is loaded and the cursor is on a folded line, peek the lines under the cursor
  if package.loaded.ufo ~= nil then
    local winid = nil
    if require("ufo.preview.floatwin").winid == nil then -- Peek window is not already opened
      -- Open peek window
      winid = require("ufo").peekFoldedLinesUnderCursor(false, false)
    else
      -- Enter in peek window
      winid = require("ufo").peekFoldedLinesUnderCursor(true, false)
    end
    if winid then -- Cursor was indeed on a folded line
      return
    end
  end

  -- Otherwise, hover with the LSP
  vim.lsp.buf.hover()
end

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

local next_diagnostic, prev_diagnostic =
  ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
M.next_diagnostic = next_diagnostic
M.prev_diagnostic = prev_diagnostic

local next_error, prev_error = ts_repeat_move.make_repeatable_move_pair(function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
M.next_error = next_error
M.prev_error = prev_error

return M
