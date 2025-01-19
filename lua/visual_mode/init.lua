-- Utilities to interact with Neovim's visual mode.

local M = {}

--- Check if the current mode is any of the visual modes (regular, line, or block).
---@return boolean
function M.is_on()
  local mode = vim.fn.mode()
  return mode == "v"
    or mode == "V" -- Visual line mode
    or mode == "\22" -- Visual block mode
end

--- Trim leading and trailing white spaces from all lines in an array and output them in a copy.
---@param lines string[] The array of lines to trim.
---@return string[]
local function trim_lines_ws(lines)
  local result = {}
  for _, value in ipairs(lines) do
    value = value:gsub("^%s+", ""):gsub("%s+$", "")
    table.insert(result, value)
  end
  return result
end

--- Trim global indentation from all lines in an array, but keeping the relative indentation, and output them in a copy.
--- For instance, for input:
---   `{'    if True:', '        print(20)'}`
--- The result of this functions is:
---   `{'if True:', '    print(20)'}`
--- This function is taken from:
---   https://github.com/mfussenegger/nvim-dap-python/blob/3dffa58541d1f52c121fe58ced046268c838d802/lua/dap-python.lua
---@param lines string[] The array of lines to trim.
---@return string[]
local function trim_lines_indent(lines)
  local offset = nil
  for _, line in ipairs(lines) do
    local first_non_ws = line:find("[^%s]") or 0
    if first_non_ws >= 1 and (not offset or first_non_ws < offset) then
      offset = first_non_ws
    end
  end
  if offset ~= nil and offset > 1 then
    return vim.tbl_map(function(x) return string.sub(x, offset) end, lines)
  else
    return lines
  end
end

--- Return the lines of the visual selection as an array with an entry for each line.
--- This function is taken from:
---   https://www.reddit.com/r/neovim/comments/1b1sv3a/function_to_get_visually_selected_text/
---@param opts table<string, any>|nil Options to customize the output.
---@return string[]
function M.get_lines(opts)
  opts = opts or {}
  local trim_ws = opts.trim_ws or false
  local trim_indent = opts.trim_indent or false

  local _, srow, scol = unpack(vim.fn.getpos("v"))
  local _, erow, ecol = unpack(vim.fn.getpos("."))

  local mode = vim.fn.mode()
  local lines = {}
  if mode == "V" then -- Visual line mode
    if srow > erow then
      lines = vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  elseif mode == "v" then
    if srow < erow or (srow == erow and scol <= ecol) then
      lines = vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      lines = vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  elseif mode == "\22" then -- Visual block mode
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(
        lines,
        vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
      )
    end
  end

  if trim_ws then
    lines = trim_lines_ws(lines)
  elseif trim_indent then
    lines = trim_lines_indent(lines)
  end

  return lines
end

--- Return the text of the visual selection in a single line (lines are concatenated with white spaces).
---@return string
function M.get_text()
  local lines = M.get_lines({ trim_ws = true })
  return table.concat(lines, " ")
end

return M
