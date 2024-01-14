local M = {}

local mods = ":p:~:."

M.get_path = function(params)
  -- In priority output the command input
  if params.args ~= "" then
    return vim.fn.fnamemodify(params.args, mods)
  end

  -- If a buffer is open, output its path
  local file_path = vim.fn.expand("%:p") -- Current file or ""
  if file_path ~= "" then
    return vim.fn.fnamemodify(file_path, mods)
  end

  -- Default to the current directory
  return "."
end

return M
