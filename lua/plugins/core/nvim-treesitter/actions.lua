local M = {}

--- Output the current line main node, that is the top-level ancestor from the node under the cursor within the same
--- line.
---@return TSNode
local get_main_node = function()
  local ts_utils = require("nvim-treesitter.ts_utils")

  local node = ts_utils.get_node_at_cursor()
  if node == nil then
    error("No Treesitter parser found.")
  end
  local start_row = node:start()
  local parent = node:parent()
  while
    parent ~= nil
    and parent:start() == start_row
    -- A "block" is typically the inner part of a function or class. Excluding it makes possible to navigate to a 
    --  sibling within a block from the first line.
    and parent:type() ~= "block"
  do
    node = parent
    parent = node:parent()
  end
  return node
end

--- Move the cursor to the parent of the current line main node.
---@return nil
M.go_to_parent_node = function()
  local ts_utils = require("nvim-treesitter.ts_utils")

  local node = get_main_node()
  local parent = node:parent()
  -- Skip not interesting nodes to avoid jumping to them
  while
    parent ~= nil
    -- Jumping to a "block" is quite useless; besides, since it's excluded in `get_main_node`, if we leave it we 
    --  can't jump to its parent once we're on it
    and parent:type() == "block"
  do
    node = parent
    parent = node:parent()
  end
  ts_utils.goto_node(parent)
end

--- Move the cursor to the next sibling of the current line main node.
---@return nil
M.next_sibling_node = function()
  local ts_utils = require("nvim-treesitter.ts_utils")

  local node = get_main_node()
  local sibling = node:next_named_sibling()
  -- Skip not interesting nodes to avoid jumping to them
  while sibling ~= nil and sibling:type() == "comment" do
    sibling = sibling:next_named_sibling()
  end
  ts_utils.goto_node(sibling)
end

--- Move the cursor to the previous sibling of the current line main node.
---@return nil
M.prev_sibling_node = function()
  local ts_utils = require("nvim-treesitter.ts_utils")

  local node = get_main_node()
  local sibling = node:prev_named_sibling()
  -- Skip not interesting nodes to avoid jumping to them
  while sibling ~= nil and sibling:type() == "comment" do
    sibling = sibling:prev_named_sibling()
  end
  ts_utils.goto_node(sibling)
end

return M
