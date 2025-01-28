-- Utilities to interact with Neovim's visual mode.

local M = {}

--- Check if the current mode is any of the visual modes (regular, line, or block).
---@return boolean
function M.is_on()
  return vim.tbl_contains({ "v", "V", "\22" }, vim.fn.mode()) -- Visual, visual line and visual block modes
end

--- Return the text of the visual selection in a single line (lines are concatenated with white spaces).
---@return string
function M.get_text()
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
  elseif mode == "v" then -- Visual mode
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

  local trimmed_lines = {}
  for _, line in ipairs(lines) do
    local trimmed_line = line:gsub("^%s+", ""):gsub("%s+$", "")
    table.insert(trimmed_lines, trimmed_line)
  end

  return table.concat(trimmed_lines, " ")
end

return M
