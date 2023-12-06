local M = {}

local get_index = function(item)
  if item == nil then
    return require("harpoon.mark").get_current_index()
  end
  return require("harpoon.mark").get_index_of(item)
end

M.add_mark = function(item)
  local idx = get_index(item)
  if idx ~= nil then
    print("File already in Harpoon mark " .. idx)
    return
  end

  require("harpoon.mark").add_file(item)
  idx = get_index(item)
  print("Mark " .. idx .. " added to Harpoon")
end

M.go_to_mark = function(item)
  local idx = require("harpoon.mark").get_index_of(item)

  if idx == nil then
    print("No mark " .. item .. " in Harpoon")
    return
  elseif idx == require("harpoon.mark").get_current_index() then
    print("Already on Harpoon mark " .. idx)
    return
  end

  require("harpoon.ui").nav_file(item)
end

return M
