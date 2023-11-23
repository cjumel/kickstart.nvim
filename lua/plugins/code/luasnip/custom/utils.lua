local M = {}

local calculate_comment_string = require("Comment.ft").calculate
local utils = require("Comment.utils")

-- Function below is taken from
-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets

--- Get the comment string { beg, end } table
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
M.get_comment_strings = function(ctype)
  -- use the `Comments.nvim` API to fetch the comment string for the region
  -- (eq. '--%s' or '--[[%s]]' for `lua`)
  local cstring = calculate_comment_string({ ctype = ctype, range = utils.get_region() })
    or vim.bo.commentstring
  -- as we want only the strings themselves and not strings ready for using `format` we want to
  -- split the left and right side
  local left, right = utils.unwrap_cstr(cstring)
  -- create a `{left, right}` table for it
  return { left, right }
end

return M
