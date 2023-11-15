local M = {}

M.is_hidden = function(name, _)
  return (name ~= "..") and vim.startswith(name, ".")
end

M.is_always_hidden = function(name, _)
  local always_hidden_names = {
    ".git",
    ".DS_Store",
    "__pycache__",
  }
  for _, always_hidden_name in ipairs(always_hidden_names) do
    if name == always_hidden_name then
      return true
    end
  end

  local always_hidden_name_starts = {
    ".null-ls_",
  }
  for _, always_hidden_name_start in ipairs(always_hidden_name_starts) do
    if vim.startswith(name, always_hidden_name_start) then
      return true
    end
  end
end

return M
