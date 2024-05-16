-- Actions used through keymaps defined in `keymaps` or in plugins themselves.

local utils = require("utils")

local M = {}

-- [[ Redefine builtin actions ]]
-- These keymaps fix or alter the behavior of builtin actions.

-- In DAP & DAP-UI, smart `a` & `i` actions don't work well with sidebar windows (it breaks the REPL)
local no_indent_filetype_prefixes = { "dap-", "dapui_" }

--- Smart version of `a` action. Builtin action doesn't automatically indent on empty line, but this version does.
---@return string
function M.smart_a()
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

--- Smart version of `i` action. Builtin action doesn't automatically indent on empty line, but this version does.
---@return string
function M.smart_i()
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

--- Smart version of `dd` action. This version avoids saving deleted empty lines in register.
---@return string
function M.smart_dd()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end

-- [[ General actions ]]
-- Define new general actions, sometimes involving multiple plugins.

--- Clear window artifacts, like highlights or floating windows.
---@return nil
function M.clear_window()
  vim.cmd("nohlsearch") -- Clear search highlights in case `vim.o.hlsearch` is true

  -- Dismiss Noice messages if Noice is loaded
  local noice = package.loaded.noice
  if noice ~= nil then
    noice.cmd("dismiss")
  end

  -- If zen-mode is loaded, fetch its window ids to avoid closing them
  local zen_mode = package.loaded["zen-mode"]
  local zen_mode_win = nil -- Main window
  local zen_mode_bg_win = nil -- Background window
  if zen_mode ~= nil then
    local zen_mode_view = require("zen-mode.view")
    if zen_mode_view.is_open() then
      zen_mode_win = zen_mode_view.win
      zen_mode_bg_win = zen_mode_view.bg_win
    end
  end

  -- Clear remaining relative windows (e.g. preview or hover floating windows) except the zen-mode windows
  for _, id in ipairs(vim.api.nvim_list_wins()) do
    local ok, win_config = pcall(vim.api.nvim_win_get_config, id) -- Handle cases of invalid window ids
    if ok and win_config.relative ~= "" and id ~= zen_mode_win and id ~= zen_mode_bg_win then
      vim.api.nvim_win_close(id, false)
    end
  end
end

--- Clear insert mode artifacts, like copilot suggestion.
---@return nil
function M.clear_insert_mode()
  -- Dismiss Copilot suggestion
  if package.loaded._copilot ~= nil then
    vim.fn["copilot#Dismiss"]()
  end

  -- Dismiss nvim-cmp suggestion
  local cmp = package.loaded.cmp
  if cmp ~= nil then
    cmp.abort()
  end
end

--- Clear all artifacts.
---@return nil
function M.clear_all()
  M.clear_window()
  M.clear_insert_mode()
end

--- Custom hover action. If nvim-ufo is loaded, it will peek the lines under the cursor. Otherwise, it will hover with
--- the LSP.
function M.hover()
  -- If nvim-ufo is loaded and the cursor is on a folded line, peek the lines under the cursor
  if package.loaded.ufo ~= nil then
    local winid = nil
    if require("ufo.preview.floatwin").winid == nil then -- Peek window is not already opened
      winid = require("ufo").peekFoldedLinesUnderCursor(false, false) -- Open peek window
    else
      winid = require("ufo").peekFoldedLinesUnderCursor(true, false) -- Enter in peek window
    end
    if winid then -- Cursor was indeed on a folded line
      return
    end
  end
  vim.lsp.buf.hover() -- Otherwise, hover with the LSP
end

M.yank = {}

--- Yank the path of the current buffer or directory if in Oil buffer.
---@param opts table|nil Optional parameters. Supported parameters are:
--- - cwd boolean: If true, yank the current working directory. Default is false.
--- - mods string: Modifications to apply to the path. Default is ":~:.".
---@return nil
local function yank_path(opts)
  opts = opts or {}
  local cwd = opts.cwd or false
  local mods = opts.mods or ":~:." -- Relative to cwd or home directory

  local path
  if cwd then
    path = vim.fn.getcwd()
  elseif vim.bo.filetype == "oil" then
    local oil = package.loaded.oil -- Oil should already have been loaded
    path = oil.get_current_dir()
  else
    path = vim.fn.expand("%")
  end

  path = vim.fn.fnamemodify(path, mods)
  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end

function M.yank.cwd() yank_path({ cwd = true, mods = ":~" }) end
function M.yank.relative_path() yank_path({ mods = ":~:." }) end
function M.yank.absolute_path() yank_path({ mods = ":~" }) end

--- Send the content of the default register to the clipboard.
---@return nil
function M.yank.send_to_clipboard()
  local yank = vim.fn.getreg('"')
  vim.fn.setreg("+", yank)
  vim.notify('Sent "' .. yank .. '" to clipboard')
end

return M
