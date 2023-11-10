local M = {}

M.add_oil_entry_to_harpoon = function()
  local entry = require("oil").get_cursor_entry()
  if entry == nil then
    return
  end
  local dir = require("oil").get_current_dir()
  local path = dir .. entry.name
  require("plugins.navigation.utils.harpoon").add_harpoon_file(path)
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
