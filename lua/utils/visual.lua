local table_utils = require("utils.table")

local M = {}

--- Check if the current mode is the regular visual mode (not line or block visual modes).
---@return boolean output True iff the current mode is the regular visual mode.
function M.is_visual_simple_mode()
  return vim.fn.mode() == "v"
end

--- Check if the current mode is the visual line mode.
---@return boolean output True iff the current mode is the visual line mode.
function M.is_visual_line_mode()
  return vim.fn.mode() == "V"
end

--- Check if the current mode is the visual block mode.
---@return boolean output True iff the current mode is the visual block mode.
function M.is_visual_block_mode()
  return vim.fn.mode() == "\22"
end

--- Check if the current mode is any visual mode (regular, line, or block).
---@return boolean output True iff the current mode is any visual mode.
function M.is_visual_mode()
  return M.is_visual_simple_mode() or M.is_visual_line_mode() or M.is_visual_block_mode()
end

--- Return the lines of the visual selection as an array with an entry for each line.
--- This function is taken from:
--- https://www.reddit.com/r/neovim/comments/1b1sv3a/function_to_get_visually_selected_text/
---@param opts table<string, any>|nil Options to customize the output.
---@return string[] lines The selected text as an array of lines.
function M.get_lines(opts)
  opts = opts or {}
  local trim_ws = opts.trim_ws or false

  local _, srow, scol = unpack(vim.fn.getpos("v"))
  local _, erow, ecol = unpack(vim.fn.getpos("."))

  local lines = {}
  if M.is_visual_line_mode() then
    if srow > erow then
      lines = vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  elseif M.is_visual_simple_mode() then
    if srow < erow or (srow == erow and scol <= ecol) then
      lines = vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      lines = vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  elseif M.is_visual_block_mode() then
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(
        lines,
        vim.api.nvim_buf_get_text(
          0,
          i - 1,
          math.min(scol - 1, ecol),
          i - 1,
          math.max(scol - 1, ecol),
          {}
        )[1]
      )
    end
  end

  if trim_ws then
    lines = table_utils.trim_ws_in_array(lines)
  end

  return lines
end

--- Return the text of the visual selection.
---@return string text Text of the visual selection.
function M.get_text()
  local lines = M.get_lines({ trim_ws = true })
  return table.concat(lines, " ")
end

return M
