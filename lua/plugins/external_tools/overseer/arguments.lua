local M = {}

local mods = ":p:~:."

M.get_path = function(params)
  if params.args ~= "" then -- An argument was passed
    return vim.fn.fnamemodify(params.args, mods)
  end

  local file_path = vim.fn.expand("%:p")

  if file_path == "" then -- No file open
    return "."
  end

  if vim.bo.filetype == "oil" then -- Oil buffer open
    local ok, oil = pcall(require, "oil")
    if ok then
      return vim.fn.fnamemodify(oil.get_current_dir(), mods)
    end
  end

  -- Regular file open
  return vim.fn.fnamemodify(file_path, mods)
end

return M
