local M = {}

M.add_oil_entry_to_harpoon = function()
  local entry = require("oil").get_cursor_entry()
  if entry == nil then
    return
  end
  local dir = require("oil").get_current_dir()
  local path = dir .. entry.name
  require("plugins.navigation.harpoon.custom.mark").add_harpoon_file(path)
end

return M
