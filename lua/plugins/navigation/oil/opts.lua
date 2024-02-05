local M = {}

M.is_hidden_file = function(name, _)
  -- Add some stuff globally git-ignored but not hidden
  if name == "__pycache__" then -- Python cache files
    return true
  end

  return vim.startswith(name, ".")
end

M.is_always_hidden = function(name, _)
  -- Displaying ".." doesn't bring neither new information nor features
  if name == ".." then
    return true
  end

  -- Don't display Neovim-related files
  if vim.startswith(name, ".null-ls_") then -- Null-ls temporary files
    return true
  end

  return false
end

return M
