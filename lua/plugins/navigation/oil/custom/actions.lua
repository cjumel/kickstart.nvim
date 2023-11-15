local M = {}

M.add_harpoon_mark_from_oil = function()
  local entry = require("oil").get_cursor_entry()
  if entry == nil then
    return
  end
  local dir = require("oil").get_current_dir()
  local path = dir .. entry.name
  require("plugins.navigation.harpoon.custom.actions").add_mark(path)
end

return M
