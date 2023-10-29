local M = {}

M.go_to_harpoon_file = function(item)
  local idx = require("harpoon.mark").get_index_of(item)
  if idx == nil then
    print("No file " .. item .. " in Harpoon")
    return
  elseif idx == require("harpoon.mark").get_current_index() then
    print("Already on Harpoon file " .. idx)
    return
  end

  require("harpoon.ui").nav_file(item)
end

return M
