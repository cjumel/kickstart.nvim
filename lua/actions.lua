local M = {}

-- [[ Redefine builtin actions ]]

-- Disable automatic indent for a & i in some filetypes
local no_indent_filetype_prefixes = {
  "dap-", -- In dap & dapui, it doesn't work well with sidebar windows (e.g. break the repl)
  "dapui_",
}

M.a_indent = function()
  for _, prefix in ipairs(no_indent_filetype_prefixes) do
    if vim.bo.filetype:sub(1, #prefix) == prefix then
      return "a"
    end
  end
  return string.match(vim.api.nvim_get_current_line(), "%g") == nil and "cc" or "a"
end

M.i_indent = function()
  for _, prefix in ipairs(no_indent_filetype_prefixes) do
    if vim.bo.filetype:sub(1, #prefix) == prefix then
      return "a"
    end
  end
  return string.match(vim.api.nvim_get_current_line(), "%g") == nil and "cc" or "i"
end

-- [[ General actions ]]

M.clear_window = function()
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

local next_paragraph, prev_paragraph = ts_repeat_move.make_repeatable_move_pair(function()
  vim.cmd("normal! }")
end, function()
  vim.cmd("normal! {")
end)
M.next_paragraph = next_paragraph
M.prev_paragraph = prev_paragraph

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

-- [[ Settings actions ]]

M.switch_line_numbering = function()
  if vim.wo.number and not vim.wo.relativenumber then
    vim.wo.relativenumber = true
  elseif vim.wo.number and vim.wo.relativenumber then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = false
  end
end

M.switch_sign_column = function()
  if vim.wo.signcolumn == "number" then
    vim.wo.signcolumn = "yes"
  elseif vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "no"
  else
    vim.wo.signcolumn = "number"
  end
end

M.toggle_ruler_column = function()
  if vim.o.colorcolumn == "101" then
    vim.o.colorcolumn = ""
  else
    vim.o.colorcolumn = "101"
  end
end

return M
