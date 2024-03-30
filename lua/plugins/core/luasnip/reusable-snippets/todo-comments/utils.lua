local comment_ft = require("Comment.ft")
local comment_utils = require("Comment.utils")
local ls = require("luasnip")

local i = ls.insert_node
local sn = ls.snippet_node
local t = ls.text_node

local M = {}

--- Get the comment string { start, end } table. Function is taken from
--- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets.
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
local get_comment_strings = function(ctype)
  -- use the `Comments.nvim` API to fetch the comment string for the region
  -- (eq. '--%s' or '--[[%s]]' for `lua`)
  local cstring = comment_ft.calculate({ ctype = ctype, range = comment_utils.get_region() })
    or vim.bo.commentstring
  -- as we want only the strings themselves and not strings ready for using `format` we want to
  -- split the left and right side
  local left, right = comment_utils.unwrap_cstr(cstring)
  -- create a `{left, right}` table for it

  if left ~= "" then
    left = left .. " "
  end
  if right ~= "" then
    right = " " .. right
  end

  return { left, right }
end

M.get_comment_string_start = function() return get_comment_strings(1)[1] end
M.get_comment_string_end = function() return get_comment_strings(1)[2] end

local tdc_keywords = {
  "TODO",
  "NOTE",
  "BUG",
  "FIXME",
  "ISSUE",
}

M.get_tdc_sn_options = function()
  local tdc_sn_options = {}
  for _, keyword in ipairs(tdc_keywords) do
    table.insert(tdc_sn_options, sn(nil, { t(keyword), t(": "), i(1) }))
  end
  return tdc_sn_options
end

return M
