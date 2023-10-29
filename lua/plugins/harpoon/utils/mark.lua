local M = {}

local get_index = function(item)
  if item == nil then
    return require("harpoon.mark").get_current_index()
  else
    return require("harpoon.mark").get_index_of(item)
  end
end

M.add_harpoon_file = function(item)
  local idx = get_index(item)
  if idx ~= nil then
    print("File already in Harpoon as file " .. idx)
    return
  end

  require("harpoon.mark").add_file(item)
  idx = get_index(item)
  print("File " .. idx .. " added to Harpoon")
end

M.remove_harpoon_file = function(item)
  local idx = get_index(item)
  if idx == nil then
    print("File not in Harpoon")
    return
  end

  require("harpoon.mark").rm_file(item)
  print("File " .. idx .. " removed from Harpoon")
end

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
